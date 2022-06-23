# PSEUDOCODE
# - config_obj = import(.config_vars.yml)
# - params = []
# - workflows = []
# - foreach(sub in react_app_subdomains) params[] = format(sub,config_react_trigger_param_template.yml)
# - foreach(sub in react_app_subdomains) workflows[] = format(sub,config_react_workflow_template.yml)
# - flatten params and workflows into vars loaded into config_obj
# - format(config_obj, convig_template.yml)
# - backup existing config.yml & output generated text
