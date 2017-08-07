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

Lung    -- EQS  
            -- FullWave.m
            -- LungEQS_MQS_validation.m
            -- FigsScriptLungEQS.m & PhiDstrbtn
            -- AFigsScript.m & ADstrbtn_Directed_H.m & LungEQS_EOnePlot.m
        -- MQS  
            -- LungMQS.m (LungMQS_Bk_amend.m)
            -- LungMQS_H0_plot.m

Liver   -- EQS  
            -- LiverEQS.m
            -- FigsScriptLiverEQS.m & PhiDstrbtnLiverEQS.m & T_plot_liver.m & TumorTmptr_FW_liver.m
        -- MQS


MQS_2 add the loop specific part; set Vrtx_bndry to 1 for the current related vertices.
LungMQS: comment the redundant part, add temperature part.
-- MQS_2 can be deleted.

git commit-m 'Prepare LiverEQS.m; '