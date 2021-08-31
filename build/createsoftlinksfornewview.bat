mklink /D ama                     ..\common\ama
mklink /D automation              ..\common\automation 
mklink /D ccl                     ..\common\ccl 
mklink /D cdl                     ..\common\cdl
mklink /D cdt                     ..\common\cdt
mklink /D cmi                     ..\common\cmi
mklink /D cta                     ..\common\cta
mklink /D dca                     ..\common\dca
mklink /D debug                   ..\common\debug
mklink /D frameworks              ..\common\frameworks
mklink /D odmon                   ..\common\odmon      
mklink /D optools                 ..\common\optools    
mklink /D scripts                 ..\common\scripts    
mklink /D subscriber              ..\common\subscriber 
mklink /D tools                   ..\common\tools      
mklink /D tra                     ..\common\tra        
mklink /D unixutils               ..\common\unixutils  
mklink /D uta                     ..\common\uta        
mklink /D utils                   ..\common\utils      
mklink /D thirdparty              ..\thirdparty        
mklink /D database                ..\ems\database      
mklink /D ems                     ..\ems               
mklink /D sce                     ..\ems\sce           
mklink /D fms                     ..\ems\fms           
mklink /D xercesc                 ..\thirdparty\xercesc
mklink /D pt                      ..\ems\pt            
pushd utils
mklink cmpvergen_x86           ..\tools\cmpvergen\obj_x86\cmpvergen_x86
mklink cmivergen_x86           ..\tools\cmivergen\obj_x86\cmivergen_x86
mklink cmpgen_x86              ..\tools\cmpgen\obj_x86\cmpgen_x86
mklink cmigen_x86              ..\tools\cmigen\obj_x86\cmigen_x86
mklink cdpgen_x86              ..\tools\cdpgen\obj_x86\cdpgen_x86
mklink cdpgen                  ..\tools\cdpgen\obj_x86\cdpgen_x86
mklink cdtgen_x86 				..\tools\cdtgen\obj\cdtgen_x86 
mklink cfggen ..\tools\cfggen\obj\cfggen 
mklink cmiverchecker ..\tools\cmiverchecker\obj\cmiverchecker
mklink fileinc ..\tools\fileinc\obj\fileinc
mklink uta ..\..\common\uta\obj\uta
echo off
FOR %I IN (..\cmi\src\*.cmp) DO mklink %~nI.cc ..\cmi\src\%~nI.cc
FOR %I IN (..\cmi\src\*.cmi) DO mklink %~nI.cc ..\cmi\src\%~nI.cc
FOR %I IN (..\cmi\src\*.cc) DO mklink %~nI.cc ..\cmi\src\%~nI.cc
echo on
popd 
