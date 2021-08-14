/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000873797888_2058220583_init();
    work_m_00000000004182824192_0652108486_init();
    work_m_00000000000244540480_2274140009_init();
    work_m_00000000000244540480_2495501377_init();
    work_m_00000000000244540480_3349931330_init();
    work_m_00000000000244540480_1214037437_init();
    work_m_00000000000244540480_1401945929_init();
    work_m_00000000000702117167_2048336009_init();
    work_m_00000000003092973079_2415336395_init();
    work_m_00000000002024329643_0886308060_init();
    work_m_00000000000691541517_1380291130_init();
    work_m_00000000003169570578_0186216794_init();
    work_m_00000000003169570578_0344333521_init();
    work_m_00000000004189373968_0516268746_init();
    work_m_00000000001433465393_1129276290_init();
    work_m_00000000003428410717_1637252873_init();
    work_m_00000000002511519150_4156653617_init();
    work_m_00000000002508913717_0856871209_init();
    work_m_00000000002508913717_0425331090_init();
    work_m_00000000002508913717_2530844696_init();
    work_m_00000000002508913717_2737335732_init();
    work_m_00000000002508913717_2452385829_init();
    work_m_00000000001048591285_2190367558_init();
    work_m_00000000001137218231_0189518199_init();
    work_m_00000000002095589154_1912338720_init();
    work_m_00000000002920722411_4036455480_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000002920722411_4036455480");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}