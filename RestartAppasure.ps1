# ReStart for AppAssure Agent
stop-service EventSystem,SENS,BITS,VSS -force
Start-Sleep -s 5
start-service SENS
Start-Sleep -s 5 
start-service EventSystem
