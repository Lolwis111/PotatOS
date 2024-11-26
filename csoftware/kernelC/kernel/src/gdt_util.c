#include "gdt_util.h"
#include "printk.h"
#include "string.h"

// Note: some of the GDT entry struct field names may not match perfectly to the TSS entries.
tss_entry_t tss_entry;

struct gdt_entry_bits the_gdt[6];

static void write_tss(struct gdt_entry_bits *g)
{
	// Compute the base and limit of the TSS for use in the GDT entry.
	uint32_t base = (uint32_t) &tss_entry;
	uint32_t limit = sizeof tss_entry;

	// Add a TSS descriptor to the GDT.
	g->limit_low = limit;
	g->base_low = base;
	g->accessed = 1; // With a system entry (`code_data_segment` = 0), 1 indicates TSS and 0 indicates LDT
	g->read_write = 0; // For a TSS, indicates busy (1) or not busy (0).
	g->conforming_expand_down = 0; // always 0 for TSS
	g->code = 1; // For a TSS, 1 indicates 32-bit (1) or 16-bit (0).
	g->code_data_segment=0; // indicates TSS/LDT (see also `accessed`)
	g->DPL = 0; // ring 0, see the comments below
	g->present = 1;
	g->limit_high = (limit & (0xf << 16)) >> 16; // isolate top nibble
	g->available = 0; // 0 for a TSS
	g->long_mode = 0;
	g->big = 0; // should leave zero according to manuals.
	g->gran = 0; // limit is in bytes, not pages
	g->base_high = (base & (0xff << 24)) >> 24; //isolate top byte

	// Ensure the TSS is initially zero'd.
	memset(&tss_entry, 0, sizeof tss_entry);

	tss_entry.ss0  = 0x10;  // Set the kernel stack segment.
	tss_entry.esp0 = 0x90000; // Set the kernel stack pointer.
	//note that CS is loaded from the IDT entry and should be the regular kernel code segment
}

void initGDT()
{
	memset(&the_gdt[0], 0, 6 * sizeof(struct gdt_entry_bits));

	// Ring 0 code
	the_gdt[1].limit_low = 0xFFFF;
	the_gdt[1].accessed = 0;
	the_gdt[1].read_write = 1;
	the_gdt[1].conforming_expand_down = 0;
	the_gdt[1].code = 1;
	the_gdt[1].code_data_segment = 1;
	the_gdt[1].DPL = 0;
	the_gdt[1].present = 1;

	the_gdt[1].limit_high = 0xF;
	the_gdt[1].available = 1;
	the_gdt[1].long_mode = 0;
	the_gdt[1].big = 1;
	the_gdt[1].gran = 1;

	the_gdt[1].base_high = 0;

	// Ring 0 data
	the_gdt[2].limit_low = 0xFFFF;
	the_gdt[2].accessed = 0;
	the_gdt[2].read_write = 1;
	the_gdt[2].conforming_expand_down = 0;
	the_gdt[2].code = 0;
	the_gdt[2].code_data_segment = 1;
	the_gdt[2].DPL = 0;
	the_gdt[2].present = 1;

	the_gdt[2].limit_high = 0xF;
	the_gdt[2].available = 1;
	the_gdt[2].long_mode = 0;
	the_gdt[2].big = 1;
	the_gdt[2].gran = 1;

	the_gdt[1].base_high = 0;

	// Ring 3 code
	the_gdt[3].limit_low = 0xFFFF;
	the_gdt[3].accessed = 0;
	the_gdt[3].read_write = 1;
	the_gdt[3].conforming_expand_down = 0;
	the_gdt[3].code = 1;
	the_gdt[3].code_data_segment = 1;
	the_gdt[3].DPL = 3;
	the_gdt[3].present = 1;

	the_gdt[3].limit_high = 0xF;
	the_gdt[3].available = 1;
	the_gdt[3].long_mode = 0;
	the_gdt[3].big = 1;
	the_gdt[3].gran = 1;

	the_gdt[3].base_high = 0;

	// Ring 3 data
	the_gdt[4].limit_low = 0xFFFF;
	the_gdt[4].accessed = 0;
	the_gdt[4].read_write = 1;
	the_gdt[4].conforming_expand_down = 0;
	the_gdt[4].code = 0;
	the_gdt[4].code_data_segment = 1;
	the_gdt[4].DPL = 3;
	the_gdt[4].present = 1;

	the_gdt[4].limit_high = 0xF;
	the_gdt[4].available = 1;
	the_gdt[4].long_mode = 0;
	the_gdt[4].big = 1;
	the_gdt[4].gran = 1;

	the_gdt[4].base_high = 0;

	write_tss(&the_gdt[5]);

	load_gdt(6*8, &the_gdt[0]);

	load_tss();

	printk("0x%p\r\n", &the_gdt[0]);
}