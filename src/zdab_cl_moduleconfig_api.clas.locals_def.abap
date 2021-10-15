TYPES:
  BEGIN OF ty_s_buffer_param_value.
    INCLUDE TYPE zdab_s_param_value_config_key.
    INCLUDE TYPE zdab_s_param_value_config_attr.
TYPES: END OF ty_s_buffer_param_value.

TYPES ty_t_buffer_param_value  TYPE STANDARD TABLE OF ty_s_buffer_param_value WITH NON-UNIQUE KEY primary_key COMPONENTS module_id param_id param_condition.

TYPES:
  BEGIN OF ty_s_buffer_param_config.
    INCLUDE TYPE zdab_s_param_config_key.
    INCLUDE TYPE zdab_s_param_config_attr.
TYPES:
    param_values TYPE ty_t_buffer_param_value.
TYPES: END OF ty_s_buffer_param_config.

TYPES ty_t_buffer_param_config TYPE STANDARD TABLE OF ty_s_buffer_param_config WITH NON-UNIQUE KEY primary_key COMPONENTS module_id param_id.

TYPES:
  BEGIN OF ty_s_buffer_module.
    INCLUDE TYPE zdab_s_module_key.
    INCLUDE TYPE zdab_s_module_attr.
TYPES:
    param_configs TYPE ty_t_buffer_param_config.
TYPES: END OF ty_s_buffer_module.

TYPES ty_t_buffer_module TYPE STANDARD TABLE OF ty_s_buffer_module WITH NON-UNIQUE KEY primary_key COMPONENTS module_id.
