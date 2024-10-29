#define DISK_PARAMETER_ADDRESS 0x000fefc7

typedef struct{
  unsigned char steprate_headunload;
  unsigned char headload_ndma;
  unsigned char motor_delay_off; /*specified in clock ticks*/
  unsigned char bytes_per_sector;
  unsigned char sectors_per_track;
  unsigned char gap_length;
  unsigned char data_length; /*used only when bytes per sector == 0*/
  unsigned char format_gap_length;
  unsigned char filler;
  unsigned char head_settle_time; /*specified in milliseconds*/
  unsigned char motor_start_time; /*specified in 1/8 seconds*/
}__attribute__ ((packed)) floppy_parameters;

#define FLOPPY_PRIMARY_BASE     0x03F0
#define FLOPPY_SECONDARY_BASE   0x0370

#define STATUS_REG_A            0x0000 /*PS2 SYSTEMS*/
#define STATUS_REG_B            0x0001 /*PS2 SYSTEMS*/
#define DIGITAL_OUTPUT_REG      0x0002
#define MAIN_STATUS_REG         0x0004
#define DATA_RATE_SELECT_REG    0x0004 /*PS2 SYSTEMS*/
#define DATA_REGISTER           0x0005
#define DIGITAL_INPUT_REG       0x0007 /*AT SYSTEMS*/
#define CONFIG_CONTROL_REG      0x0007 /*AT SYSTEMS*/
#define PRIMARY_RESULT_STATUS   0x0000
#define SECONDARY_RESULT_STATUS 0x0000

/*controller commands*/
#define FIX_DRIVE_DATA          0x03
#define CHECK_DRIVE_STATUS      0x04
#define CALIBRATE_DRIVE         0x07
#define CHECK_INTERRUPT_STATUS  0x08
#define FORMAT_TRACK            0x4D
#define READ_SECTOR             0x66
#define READ_DELETE_SECTOR      0xCC
#define READ_SECTOR_ID          0x4A
#define READ_TRACK              0x42
#define SEEK_TRACK              0x0F
#define WRITE_SECTOR            0xC5
#define WRITE_DELETE_SECTOR     0xC9

void init()
{
    floppy_parameters floppy_disk; /*declare variable of floppy_parameters type*/
    memcpy(&floppy_disk, (unsigned char *)DISK_PARAMETER_ADDRESS, sizeof(floppy_parameters));
}

void reset_floppy_controller(int base, char drive)
{
  outportb((base+DIGITAL_OUTPUT_REG),0x00); /*disable controller*/
  outportb((base+DIGITAL_OUTPUT_REG),0x0c); /*enable controller*/
    kreceive_message(floppy_mailbox,&fmess); /*this suspends the driver until
                                             the controller issues an
                                             interrupt*/
  check_interrupt_status(base,&st0,&cylinder);
   outportb(base+CONFIG_CONTROL_REG,0);
  configure_drive(base,drive);
    calibrate_drive(base,drive);
  return;
}

void calibrate_drive(int base,char drive){
  motor_control(drive,START); /*turns the motor of drive ON*/
  write_floppy_command(base,CALIBRATE_DRIVE); /*Calibrate drive*/
  write_floppy_command(base,drive);
  kreceive_message(floppy_mailbox,&fmess);  /*wait for interrupt from
                                              controller*/
  check_interrupt_status(base,&st0,&cylinder); /*check interrupt status and
                                                store results in global variables
                                                st0 and cylinder*/
 return;
}

void check_interrupt_status(int base,unsigned char *st0,unsigned char *cylinder){
             write_floppy_command(base,CHECK_INTERRUPT_STATUS);
             wait_floppy_data(base);
             *st0=inportb(base+DATA_REGISTER);
             wait_floppy_data(base);
              *cylinder=inportb(base+DATA_REGISTER);
  return;
}

void wait_floppy_data(int base){
/*     read main status register of controller and wait until it signals that
     data is ready in the data register*/

  while(((inportb(base+MAIN_STATUS_REG))&0xd0)!=0xd0);
 return;
}

void configure_drive(int base,char drive){
  write_floppy_command(base,FIX_DRIVE_DATA);/*config/specify command*/
  write_floppy_command(base,floppy_disk.steprate_headunload);
  write_floppy_command(base,floppy_disk.headload_ndma);
  return;
}

void write_floppy_command(int base,char command){
   wait_floppy_ready(base);
   outportb(base+DATA_REGISTER,command);
   return;
}

void read_sector(unsigned char sector,unsigned char head,unsigned char cylinder,unsigned char drive,unsigned long buffer)
{
   seek_track(head,cylinder,drive);

   start_dma(0x02,0x44,buffer,511);

   k_delay(floppy_disk.head_settle_time);

   write_floppy_command(FLOPPY_PRIMARY_BASE,READ_SECTOR);
   write_floppy_command(FLOPPY_PRIMARY_BASE,head<<2|drive);
   write_floppy_command(FLOPPY_PRIMARY_BASE,cylinder);
   write_floppy_command(FLOPPY_PRIMARY_BASE,head);
   write_floppy_command(FLOPPY_PRIMARY_BASE,sector);
   write_floppy_command(FLOPPY_PRIMARY_BASE,floppy_disk.bytes_per_sector);  /*sector size = 128*2^size*/
   write_floppy_command(FLOPPY_PRIMARY_BASE,floppy_disk.sectors_per_track); /*last sector*/
   write_floppy_command(FLOPPY_PRIMARY_BASE,floppy_disk.gap_length);        /*27 default gap3 value*/
   write_floppy_command(FLOPPY_PRIMARY_BASE,floppy_disk.data_length);       /*default value for data length*/

   kreceive_message(floppy_mailbox,&fmess); /*wait for interrupt to signal
                                              completion of read sector command*/

   check_interrupt_status(FLOPPY_PRIMARY_BASE,&st0,&cylinder);
      read_result_phase();
   return;
}

void read_result_phase()
{

  unsigned char status;
  int timeout=16;

  while(timeout--)
  {
         wait_floppy_ready(FLOPPY_PRIMARY_BASE);
         status=inportb(FLOPPY_PRIMARY_BASE+MAIN_STATUS_REG);
         if((status&0xd0) != 0xd0)
            break;

         status=inportb(FLOPPY_PRIMARY_BASE+DATA_REGISTER);
  }
  return;
}