CLASS zcl_if_runtest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS generate_customers.
    CLASS-METHODS create_customer
      IMPORTING create1 TYPE abap_bool.

    DATA: go_runtime TYPE REF TO zcl_if_runtest.
    DATA: gt_customers TYPE TABLE OF zrla_customer.
    DATA: gs_customer TYPE zrla_customer.
    DATA: gv_idcustomer TYPE zrla_customer-customer_id.
    DATA: gv_message TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_if_runtest IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    generate_customers( ).
    create_customer( create1 = 'X' ).

    IF sy-subrc EQ 0.
      out->write( | OK | ).
    ENDIF.

  ENDMETHOD.

  METHOD create_customer.

    DATA: system_uuid TYPE REF TO if_system_uuid.
    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    DATA: lt_create_data TYPE TABLE FOR CREATE zdd_r_customer,
          ls_create_data LIKE LINE OF lt_create_data.

    generate_customers(  ).

    IF create1 EQ 'X'.

      TRY.
          DATA(lv_uuid) = system_uuid->create_uuid_x16( ).
        CATCH cx_uuid_error.
          EXIT.
      ENDTRY.

      ls_create_data-%cid       = lv_uuid.
      ls_create_data-Firstname  = 'Dummy'.
      ls_create_data-Lastname   = 'Dumb'.

      ls_create_data-%control-Firstname  = if_abap_behv=>mk-on.
      ls_create_data-%control-LastName   = if_abap_behv=>mk-on.

      APPEND ls_create_data TO lt_create_data.

      MODIFY ENTITIES OF zdd_r_customer
       ENTITY Customer
       CREATE FROM lt_create_data
       FAILED   DATA(ls_create_failed)
       REPORTED DATA(ls_create_reported)
       MAPPED   DATA(ls_create_mapped).

      IF ls_create_failed IS INITIAL.
        COMMIT ENTITIES.
      ELSE.
        ROLLBACK ENTITIES.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD generate_customers.

    DATA: system_uuid TYPE REF TO if_system_uuid.
    DATA: lt_dummy TYPE TABLE OF i.
    DATA: lv_uuid TYPE sysuuid_x16.
    DATA: ls_customer TYPE zrla_customer.
    DATA: lt_customers TYPE TABLE OF zrla_customer.

    lt_dummy = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ).
    DELETE FROM zrla_customer.

    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    LOOP AT lt_dummy INTO DATA(lv_number).

      TRY.
          lv_uuid = system_uuid->create_uuid_x16( ).
        CATCH cx_uuid_error.
          EXIT.
      ENDTRY.

      CLEAR ls_customer.

      ls_customer-customer_id = lv_uuid.
      ls_customer-firstname   = |Name{ lv_number }|.
      ls_customer-lastname    = |Lastname{ lv_number }|.
      ls_customer-title       = 'Sr.'.
      ls_customer-phone       = |+35191234{ lv_number }|.
      ls_customer-email       = |cliente{ lv_number }@teste.com|.
      ls_customer-gender      = 'M'.                          " ou 'F'
      ls_customer-website     = |www.site{ lv_number }.com|.
      ls_customer-createdby   = cl_abap_context_info=>get_user_technical_name( ).
      ls_customer-createdat   = cl_abap_context_info=>get_system_date( ).
      ls_customer-changedby   = cl_abap_context_info=>get_user_technical_name( ).
      ls_customer-changedat   = cl_abap_context_info=>get_system_date( ).
      ls_customer-birthdate   = |1990{ lv_number }01|.
      APPEND ls_customer TO lt_customers.
      CLEAR ls_customer.

    ENDLOOP.

    MODIFY zrla_customer FROM TABLE @lt_customers.

  ENDMETHOD.

ENDCLASS.
