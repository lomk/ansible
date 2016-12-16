#!/usr/bin/python

#---- Logic Start ------------------------------------------------------------#
def main():
    # Note: 'AnsibleModule' is an Ansible utility imported below
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(required=True),
            success = dict(default=True, type='bool'),
        ),
        supports_check_mode=True
    )
#    success = module.params['success']
    text = module.params['name']
#    if success:
#      module.exit_json(text=text)
#    else:
#      module.fail_json(msg=text)
#    module.exit_json(changed=True, meta="TESTING", msg=text)
    module.exit_json(msg=text)
    print "test2"
    return "test1"

#---- Import Ansible Utilities (Ansible Framework) ---------------------------#
from ansible.module_utils.basic import *
main()