namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.65
    - username: root
    - password: admin@123
    - filename: accountservice.war
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 55
        y: 105
        navigate:
          287e7569-8576-b6f4-cae1-f3e2aa56d178:
            targetId: f76b9da7-755e-ae44-c5bf-8497ea235311
            port: SUCCESS
    results:
      SUCCESS:
        f76b9da7-755e-ae44-c5bf-8497ea235311:
          x: 273
          y: 105
