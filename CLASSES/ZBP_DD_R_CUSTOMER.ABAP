CLASS lhc_Customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Customer RESULT result.
    METHODS set_to_archived FOR MODIFY
      IMPORTING keys FOR ACTION customer~set_to_archived.
    METHODS determine_website FOR DETERMINE ON MODIFY
      IMPORTING keys FOR customer~determine_website.
    METHODS validate_gender FOR VALIDATE ON SAVE
      IMPORTING keys FOR customer~validate_gender.

ENDCLASS.

CLASS lhc_Customer IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD set_to_archived.

    READ ENTITY IN LOCAL MODE zdd_r_customer
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_customers).

    LOOP AT lt_customers ASSIGNING FIELD-SYMBOL(<ls_customer>).

      IF <ls_customer>-Archived = abap_true.
*        APPEND VALUE #(
*            %tky = <ls_customer>-%tky
*            %msg = NEW zcl_rla_messages(
*                textid   = zcl_rla_messages=>already_archived
*                severity = if_abap_behv_message=>severity-error
*            )
*        ) TO reported-customer.
      ELSE.
        MODIFY ENTITIES OF zdd_r_customer IN LOCAL MODE
        ENTITY Customer
        UPDATE
        SET FIELDS WITH VALUE #( (
          %tky-CustomerId = <ls_customer>-CustomerId
          Archived        = abap_true
        ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD determine_website.

    READ ENTITY IN LOCAL MODE zdd_r_customer
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_customers).

    LOOP AT lt_customers ASSIGNING FIELD-SYMBOL(<ls_customer>).

      IF <ls_customer>-Website IS INITIAL.
        MODIFY ENTITY IN LOCAL MODE zdd_r_customer
        UPDATE FIELDS ( Website )
        WITH VALUE #( FOR key IN keys (
            %tky    = key-%tky
            Website = 'www.clouddna.at'
         ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validate_gender.
  
  ENDMETHOD.

ENDCLASS.
