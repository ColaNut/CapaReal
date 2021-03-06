# CapaReal
3-d case with shifted grid

10/05: Grid shift in 2d.

10/06: Full 2d map.

10/10: Grid shift in 3d.

11/05: The runnint time to plot Phi and SAR for XZ, YZ and ZY 
are 161 (s), 64 (s) and 91 (s), respectively. 

11/09: The runnint time to plot real case Phi and SAR for XZ, YZ and ZY 
are 346 (s), 184 (s) and 807 (s), respectively.

The cal48TtrVol.m was cal8TtrVol.m not used. 

01/03: The electrode parameters are stored in UpElectrode.m, DwnElectrode.m, plotMap.m and plotYZ.m.

01/15: Need to build up the table to check SegMed: the two adjacent face (tetrahedran) should has the same medium value. 

01/17: 1. Need to reconsider the convection flags in bio-heat equation to make sense with the temperature distribution. 
             
             2. Since octantCube.m was cylinder-based model, it fails occasionally in the boundary of sphere or ellipsoid.
             Hence, a more accurate segment detection algorithm is needed. 
             
             3. Since the original code was a fast developed version, it was un-extendable somewhat. 
             And the medical important part: the ribs and bones were no incorporated in this model.
             If these two items will to be considered, the corresponding narrow gap bwtween two boundary points will cause extra effort in detecting the segment value,

             4. In conclusion, the development was suspended temporarily.

02/06: PowerMani.m calculate the temperature up to 50 min.
             ManiScript.m plot for \Phi, SAR, temperature-time and temperature distribution.

04/14: Fix a bug in putOnCurrent.m in dealing with quadrant III.

04/16: Debug list: check the input of the 28 cases.
             Check the squeeze function

05/10: Modify to a smaller model.

06/30: calH_2 is now calE^(1); 
Similar calculation are related in getWmJ.m, get6E4V_omega.m, calKVE_TetPatch_Right.m, getBk.m.

07/07: plotPntH.m is now log10(.)

08/06: supported of regular-tetrahedron code.

08/07: 

Lung -- EQS  
                -- LungEQS.m
                -- LungEQS_MQS_validation.m
                -- FigsScriptLungEQS.m & PhiDstrbtn
                -- AFigsScript.m & ADstrbtn_Directed_H.m & LungEQS_EOnePlot.m
                -- MQS -- conformal
                -- LungMQS.m (LungMQS_Bk_amend.m)
                -- LungMQS_H0_plot.m
                -- LungMQS_absH0_plot.m

Liver   -- EQS  
                        -- LiverEQS.m
                        -- FigsScriptLiverEQS.m & PhiDstrbtnLiverEQS.m & T_plot_liver.m & TumorTmptr_FW_liver.m
                -- MQS -- conformal


LungMQS:  add the loop specific part; 
                    set Vrtx_bndry to 1 for the current related vertices; 
                    comment the redundant part, add temperature part.

Need to merge LungMQS_conformal_amend.m and LungMQS_conformal.m 

08/16:
Lung    -- EQS  -- tumor temperature comparison
                -- MQS  -- conformal current sheet with bolus

Liver   -- EQS  -- updating Loop liver colission

Test    -- update the getRoughMed_Mag.m
                -- fix K_2 matrix

09/10:   Cervix MQS; loadParas_Colon and Plot E^(0) field for cervixEQS
                Modification of liver therml properties, electrode size and position in liverEQS, computational domain in liverEQS.
                Test different epsilon of insulator; modify the sigma of bolus.

09/14:   Fail to test intra-cervical electrodes and a pair of coils with opposite direction. 
                Implement: determination of SegMed for cervix model; liver plotting; \xi of HCC; Geometric parameters of cervix
                Notes: Fix the problem of Vrtx_bndry and BndryTable, where the former is for the filling of K and the latter is for the filling of d_k.

09/21:   Build a small model to test for the xy-coil.
                First version of SegMed with EQS and MQS temperature report.

09/22:  Suspended version of rough resolution (esophageal cancer)

10/02:  
LungEQS: Gray plotting; 
EsoEQS: Suspended for nested esophageal cancer.
                plot SAR in interpolation (XZ, XY)
                    -- successul for Phi distrubution
                    -- Phi_Plot_Esophagus.m for the Phi plotting; 
                    -- PhiDstrbtn_esophagus_B for SAR plotting.
                            -- Wrong determination of SegMed ?
                Temperature distribution
                    -- failed
10/06: 
    the v2Crdnt, VrtxValidFx, and A_MNEllv_2_B_MNEllv are three esophageal specific code. 
    For smaller case, modificatio of these three fx are needed.
    Namely, fillUVd_B.m filld_B.m and fillS1_Eso.m.

10/08: 
    -- EsoEQS: 
        -- plot SAR in interpolation (YZ)
        -- T_plot_Esophagus_Fine.m
        -- yet for small case 
    -- EsoMQS: 
        -- plot |E| and SAR

10/11: 
    -- plot LungEQS, LungMQS, Liver black-and-white figures
    -- EsoEQS
        -- Update SegMed in esophagus region
        -- incorporate SegMed and shiftTable in Domain A
        -- fail to speed up
            -- detectRelapse.m
    -- EsoMQS
        -- incorporate SegMed and shiftTable in Domain A

10/15: 
    -- EsophagusEQS_Fine_Amend.m and EsophagusMQS_Fine_Amend are usable
    -- before implement the new configuration

10/22:
    -- plot for shifted T for EQS and MQS
    -- Add short, double and octant coil

10/23:
    -- the loadParas and and loadParas_Eso0924 has been used in many functions.

10/30:
    -- the esophageal cancer has been suspended -> directed to LungEQS modification

12/17: 
    -- Liver MQS
        -- (1) Test for non-linear \xi
                    -- retrieve the temperature within the tetrahedron
                        -- implement MedTetTable_TCell
                            -- getPntMedTetTable_2_T -- done
                    -- check the load .mat file -- done
                    -- implement the temperature-depedent function of muscle \xi
        -- (2) Incorporate fat and modify the parameter in both capacitive and magnetic HT

03/14: -- a temporary version
Liver EQS, MQS
        -- (1) Temperature-dependent thermal properties.
        -- (2) T_plot_liverEQS_constantXi.m
        -- (3) test for the additional adipose tissue
Lung EQS
        -- (1) PhiDstrbtn modification
            -- test for the additional adipose tissue

04/13: the branch ``High_Impedance_Fat'' should have been named ``Low_Impedance_Fat''
Lung EQS
    Constant \xi: 
        -- \xi_{\rm muscle} = 2.18e-6
        -- \xi_{\rm adipose} = 0.6e-6
    The 10-fold \sigma of adipose tissue is applied.


2018/11/2 -- latest version
Lung EQS
    I have 
    1. injected saline water to both adipose tissue and muscle tissue.
    2. apply the liposuction to the model. 

I have ruined the previous README.md OAO: I replace the updated one with the older one in the remote computer.
I hope the current code are the latest. 