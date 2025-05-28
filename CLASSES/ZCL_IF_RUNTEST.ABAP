CLASS zcl_if_runtest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    "CRUD OPERATIONS
    CLASS-METHODS generate_customers.
    CLASS-METHODS create_customer1.
    CLASS-METHODS create_customer2.
    CLASS-METHODS read_customer1.
    CLASS-METHODS read_customer2.
    CLASS-METHODS update_customer.
    CLASS-METHODS delete_customer.

    "ACTION OPERATIONS
    CLASS-METHODS set_to_archived.

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
    create_customer1( ).
*    create_customer2( ).
*    read_customer1( ).
*    read_customer2( ).
*    update_customer( ).
*    delete_customer( ).
*    set_to_archived( ).

    IF sy-subrc EQ 0.
      out->write( | OK | ).
    ENDIF.

  ENDMETHOD.

  METHOD create_customer1.

    DATA: system_uuid TYPE REF TO if_system_uuid.
    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    DATA: lt_create_data TYPE TABLE FOR CREATE zdd_r_customer,
          ls_create_data LIKE LINE OF lt_create_data.

    generate_customers( ).

    TRY.
        DATA(lv_uuid) = system_uuid->create_uuid_x16( ).
      CATCH cx_uuid_error.
        EXIT.
    ENDTRY.

    ls_create_data-%cid       = lv_uuid.
    ls_create_data-Firstname  = 'Dummy'.
    ls_create_data-Lastname   = 'Dumb'.
    ls_create_data-Gender     = 'M'.

    ls_create_data-%control-Firstname = if_abap_behv=>mk-on.
    ls_create_data-%control-LastName  = if_abap_behv=>mk-on.
    ls_create_data-%control-Gender    = if_abap_behv=>mk-on.

    APPEND ls_create_data TO lt_create_data.

    MODIFY ENTITIES OF zdd_r_customer
     ENTITY Customer
     CREATE FROM lt_create_data
     FAILED   DATA(ls_create_failed)
     REPORTED DATA(ls_create_reported)
     MAPPED   DATA(ls_create_mapped).

    "get response for validation
    COMMIT ENTITIES RESPONSE OF zdd_r_customer REPORTED DATA(response).

    IF ls_create_failed IS INITIAL AND response IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD create_customer2.

    generate_customers( ).

    MODIFY ENTITIES OF zdd_r_customer
     ENTITY Customer
      CREATE AUTO FILL CID
      SET FIELDS WITH VALUE #( (
       FirstName = 'Dummy2'
       LastName  = 'Dumb2'
       ) )
      FAILED   DATA(ls_create_failed2)
      REPORTED DATA(ls_create_reported2)
      MAPPED   DATA(ls_create_mapped2).

    IF ls_create_failed2 IS NOT INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD read_customer1.

    DATA: lt_read_data TYPE TABLE FOR READ RESULT zdd_r_customer.

    READ ENTITIES OF zdd_r_customer
     ENTITY Customer
      FIELDS ( Firstname )
      WITH VALUE #( (
        %tky-CustomerId = '72B8924CCC321FD08EF54B601D6B199E'
       ) )
      RESULT lt_read_data.

    IF lt_read_data IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD read_customer2.

    DATA: lt_read_data2 TYPE TABLE FOR READ RESULT zdd_r_customer.

    READ ENTITIES OF zdd_r_customer
    ENTITY Customer
    ALL FIELDS WITH
    VALUE #( (
        %tky-CustomerId = '72B8924CCC321FD08EF54B601D6B199E'
    ) )
    RESULT lt_read_data2.

    IF lt_read_data2 IS NOT INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD update_customer.

    MODIFY ENTITIES OF zdd_r_customer
    ENTITY Customer
    UPDATE
    SET FIELDS WITH VALUE #( (
        %tky-CustomerId = '72B8924CCC321FD08EF54B601D6B199E'
        FirstName       = 'Name Dummy'
        LastName        = 'Updated'
    ) )
    FAILED   DATA(ls_update_failed)
    REPORTED DATA(ls_update_reported)
    MAPPED   DATA(ls_update_mapped).

    IF ls_update_failed IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD delete_customer.

    MODIFY ENTITIES OF zdd_r_customer
    ENTITY Customer
    DELETE FROM VALUE #( (
        %tky-CustomerId = '72B8924CCC321FD08EF54B601D6B199E'
    ) )
    FAILED   DATA(ls_delete_data)
    REPORTED DATA(ls_delete_reported)
    MAPPED   DATA(ls_delete_mapped).

    IF ls_delete_data IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD set_to_archived.

    MODIFY ENTITIES OF zdd_r_customer
      ENTITY Customer
      EXECUTE set_to_archived FROM VALUE #( (
        %tky-CustomerId =  '72B8924CCC321FD08EF54B601D6B199E'
      ) )
     FAILED   DATA(ls_action_failed)
     REPORTED DATA(ls_action_reported)
     MAPPED   DATA(ls_action_mapped).

    IF ls_action_failed IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
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
      ls_customer-archived    = ''.
      APPEND ls_customer TO lt_customers.
      CLEAR ls_customer.

    ENDLOOP.

    MODIFY zrla_customer FROM TABLE @lt_customers.

  ENDMETHOD.

ENDCLASS.
