namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: "${get_sp('vm_host')}"
    - account_service_host: "${get_sp('vm_host')}"
    - db_host: "${get_sp('vm_host')}"
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: "${get_sp('vm_username')}"
              - password: "${get_sp('vm_password')}"
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - script_url: "${get_sp('script_deploy_war')}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 139
        y: 109
      deploy_tm_wars:
        x: 339
        y: 105
        navigate:
          9a363a30-915d-d91e-7adc-86c48594acf1:
            targetId: fd0f5e08-deed-2abb-ad61-4ea5f1975a4c
            port: SUCCESS
    results:
      SUCCESS:
        fd0f5e08-deed-2abb-ad61-4ea5f1975a4c:
          x: 519
          y: 109
