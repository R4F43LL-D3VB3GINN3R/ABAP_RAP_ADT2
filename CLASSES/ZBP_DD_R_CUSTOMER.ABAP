CLASS lhc_Customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS set_to_archived FOR MODIFY
      IMPORTING keys FOR ACTION customer~set_to_archived.
    METHODS determine_website FOR DETERMINE ON MODIFY
      IMPORTING keys FOR customer~determine_website.
    METHODS validate_gender FOR VALIDATE ON SAVE
      IMPORTING keys FOR customer~validate_gender.

ENDCLASS.

CLASS lhc_Customer IMPLEMENTATION.

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

    READ ENTITY IN LOCAL MODE zdd_r_customer
    FIELDS ( Gender ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_customers).

    LOOP AT lt_customers INTO DATA(ls_customer).

      IF ls_customer-Gender NE 'M' AND  ls_customer-Gender NE 'F'.

        APPEND VALUE #( %tky = ls_customer-%tky ) TO failed-customer.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
            %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'Choose M or F for Gender'
            ) )
        TO reported-customer.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE zdd_r_customer
    FIELDS ( Archived Birthdate ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_customers).

    result = VALUE #(
    FOR <customer> IN lt_customers
      (
        %tky = <customer>-%tky
        %features-%update = COND #(
          WHEN <customer>-Archived = abap_true
          THEN if_abap_behv=>fc-o-disabled
        )
      )
    ).

  ENDMETHOD.

ENDCLASS.
