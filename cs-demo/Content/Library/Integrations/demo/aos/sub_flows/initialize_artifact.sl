namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.65
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 186
        y: 91
      copy_artifact:
        x: 15
        y: 245
      copy_script:
        x: 321
        y: 246
      execute_script:
        x: 22
        y: 461
      delete_script:
        x: 212
        y: 466
      has_failed:
        x: 411
        y: 448
        navigate:
          3f5b1263-5682-7796-5814-bee8511bb3d6:
            targetId: 2259c359-c2d6-93ff-7d08-8623a35c9280
            port: 'TRUE'
          ecd9cc53-56cb-080a-5fbe-3591db83c93c:
            targetId: 760f8854-7278-572a-453a-9ede4cdc4ea2
            port: 'FALSE'
    results:
      SUCCESS:
        2259c359-c2d6-93ff-7d08-8623a35c9280:
          x: 535
          y: 306
      FAILURE:
        760f8854-7278-572a-453a-9ede4cdc4ea2:
          x: 542
          y: 457
