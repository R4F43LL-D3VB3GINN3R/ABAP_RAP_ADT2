CLASS zcl_rla_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*    CONSTANTS:
*      BEGIN OF archived_success,
*        msgid TYPE symsgid VALUE 'Sucessful Archived',
*        msgno TYPE symsgno VALUE '1',
*        attr1 TYPE scx_attrname VALUE '',
*        attr2 TYPE scx_attrname VALUE '',
*        attr3 TYPE scx_attrname VALUE '',
*        attr4 TYPE scx_attrname VALUE '',
*      END OF archived_success,
*      BEGIN OF already_success,
*        msgid TYPE symsgid VALUE 'Already Archived',
*        msgno TYPE symsgno VALUE '2',
*        attr1 TYPE scx_attrname VALUE '',
*        attr2 TYPE scx_attrname VALUE '',
*        attr3 TYPE scx_attrname VALUE '',
*        attr4 TYPE scx_attrname VALUE '',
*      END OF already_success.
*
*    INTERFACES if_abap_behv_message.
*    INTERFACES if_t100_message.
*    INTERFACES if_t100_dyn_msg.
*
*    METHODS constructor
*      IMPORTING
*        !textid   LIKE if_t100_message=>t100key OPTIONAL
*        !previous LIKE previous OPTIONAL
*        !severity TYPE if_abap_behv_message~t_severity OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rla_messages IMPLEMENTATION.


ENDCLASS.
