CLASS lhc_Customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Customer RESULT result.
    METHODS set_to_archived FOR MODIFY
      IMPORTING keys FOR ACTION customer~set_to_archived.

ENDCLASS.

CLASS lhc_Customer IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD set_to_archived.

    LOOP AT keys INTO DATA(ls_key).
      MODIFY ENTITIES OF zdd_r_customer IN LOCAL MODE
        ENTITY Customer
        UPDATE
        SET FIELDS WITH VALUE #( (
          %tky-CustomerId = ls_key-CustomerId
          Archived        = abap_true
        ) ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
