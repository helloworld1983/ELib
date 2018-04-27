/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_397(char*, char *);
extern void execute_398(char*, char *);
extern void execute_399(char*, char *);
extern void execute_447(char*, char *);
extern void execute_401(char*, char *);
extern void execute_403(char*, char *);
extern void execute_405(char*, char *);
extern void execute_407(char*, char *);
extern void execute_409(char*, char *);
extern void execute_411(char*, char *);
extern void execute_413(char*, char *);
extern void execute_415(char*, char *);
extern void execute_417(char*, char *);
extern void execute_419(char*, char *);
extern void execute_421(char*, char *);
extern void execute_423(char*, char *);
extern void execute_425(char*, char *);
extern void execute_427(char*, char *);
extern void execute_429(char*, char *);
extern void execute_431(char*, char *);
extern void execute_433(char*, char *);
extern void execute_435(char*, char *);
extern void execute_437(char*, char *);
extern void execute_439(char*, char *);
extern void execute_441(char*, char *);
extern void execute_443(char*, char *);
extern void execute_445(char*, char *);
extern void execute_20(char*, char *);
extern void execute_21(char*, char *);
extern void execute_28(char*, char *);
extern void execute_29(char*, char *);
extern void execute_23(char*, char *);
extern void execute_24(char*, char *);
extern void execute_86(char*, char *);
extern void execute_87(char*, char *);
extern void execute_88(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_121(char*, char *);
extern void execute_123(char*, char *);
extern void execute_124(char*, char *);
extern void execute_134(char*, char *);
extern void execute_135(char*, char *);
extern void execute_235(char*, char *);
extern void execute_236(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_269(char*, char *);
extern void execute_270(char*, char *);
extern void execute_312(char*, char *);
extern void execute_313(char*, char *);
extern void execute_332(char*, char *);
extern void execute_333(char*, char *);
extern void execute_335(char*, char *);
extern void execute_336(char*, char *);
extern void execute_337(char*, char *);
extern void execute_353(char*, char *);
extern void execute_354(char*, char *);
extern void execute_2281(char*, char *);
extern void execute_2303(char*, char *);
extern void execute_2283(char*, char *);
extern void execute_2285(char*, char *);
extern void execute_2287(char*, char *);
extern void execute_2289(char*, char *);
extern void execute_2291(char*, char *);
extern void execute_2293(char*, char *);
extern void execute_2295(char*, char *);
extern void execute_2297(char*, char *);
extern void execute_2299(char*, char *);
extern void execute_2301(char*, char *);
extern void execute_2170(char*, char *);
extern void execute_2171(char*, char *);
extern void execute_2181(char*, char *);
extern void execute_2182(char*, char *);
extern void execute_2198(char*, char *);
extern void execute_2199(char*, char *);
extern void execute_2200(char*, char *);
extern void execute_2216(char*, char *);
extern void execute_2217(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_2(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_12(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_209(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_215(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_414(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_613(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_812(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[92] = {(funcp)execute_16, (funcp)execute_17, (funcp)execute_397, (funcp)execute_398, (funcp)execute_399, (funcp)execute_447, (funcp)execute_401, (funcp)execute_403, (funcp)execute_405, (funcp)execute_407, (funcp)execute_409, (funcp)execute_411, (funcp)execute_413, (funcp)execute_415, (funcp)execute_417, (funcp)execute_419, (funcp)execute_421, (funcp)execute_423, (funcp)execute_425, (funcp)execute_427, (funcp)execute_429, (funcp)execute_431, (funcp)execute_433, (funcp)execute_435, (funcp)execute_437, (funcp)execute_439, (funcp)execute_441, (funcp)execute_443, (funcp)execute_445, (funcp)execute_20, (funcp)execute_21, (funcp)execute_28, (funcp)execute_29, (funcp)execute_23, (funcp)execute_24, (funcp)execute_86, (funcp)execute_87, (funcp)execute_88, (funcp)execute_119, (funcp)execute_120, (funcp)execute_121, (funcp)execute_123, (funcp)execute_124, (funcp)execute_134, (funcp)execute_135, (funcp)execute_235, (funcp)execute_236, (funcp)execute_249, (funcp)execute_250, (funcp)execute_252, (funcp)execute_253, (funcp)execute_269, (funcp)execute_270, (funcp)execute_312, (funcp)execute_313, (funcp)execute_332, (funcp)execute_333, (funcp)execute_335, (funcp)execute_336, (funcp)execute_337, (funcp)execute_353, (funcp)execute_354, (funcp)execute_2281, (funcp)execute_2303, (funcp)execute_2283, (funcp)execute_2285, (funcp)execute_2287, (funcp)execute_2289, (funcp)execute_2291, (funcp)execute_2293, (funcp)execute_2295, (funcp)execute_2297, (funcp)execute_2299, (funcp)execute_2301, (funcp)execute_2170, (funcp)execute_2171, (funcp)execute_2181, (funcp)execute_2182, (funcp)execute_2198, (funcp)execute_2199, (funcp)execute_2200, (funcp)execute_2216, (funcp)execute_2217, (funcp)transaction_0, (funcp)transaction_2, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_12, (funcp)transaction_209, (funcp)transaction_215, (funcp)transaction_414, (funcp)transaction_613, (funcp)transaction_812};
const int NumRelocateId= 92;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/test_encoders_behav/xsim.reloc",  (void **)funcTab, 92);
	iki_vhdl_file_variable_register(dp + 270192);
	iki_vhdl_file_variable_register(dp + 270248);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/test_encoders_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/test_encoders_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/test_encoders_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/test_encoders_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/test_encoders_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
