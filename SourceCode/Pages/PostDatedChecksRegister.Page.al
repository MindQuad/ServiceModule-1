page 50077 "Post Dated Checks Register"
{
    // WINPDC : Created new function for Revoke Cheque 'UpdateStatusRevoked' and added new button for the same.
    // WINPDC : Added code on actiosn button 'CreateCashJournal & Post' and 'CreateCashJournal' to check status Revoked.
    // WINPDC : Shown Cheque Dropped field | Created new function for Revoke Cheque 'UpdateChequeDropped' and added new button for the same.
    // WINPDC : Added code on On Assist Trigger on Document No. for No. Series.
    // WINPDC : Added Code on Action Button to change status and create and post journal for cash entries.

    AutoSplitKey = false;
    Caption = 'PDC Entries';
    CardPageID = "Post Dated Check Card";
    DelayedInsert = false;
    PageType = Document;
    UsageCategory = Lists;
    ApplicationArea = All;
    SaveValues = true;
    SourceTable = "Post Dated Check Line";
    SourceTableView = SORTING("Line Number")
                      WHERE("Account Type" = FILTER(' ' | Customer | "G/L Account"));

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                Visible = false;
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        DateFilterOnAfterValidate;
                    end;
                }
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(CustomerList);
                        CustomerList.LOOKUPMODE(TRUE);
                        IF NOT (CustomerList.RUNMODAL = ACTION::LookupOK) THEN
                            EXIT(FALSE);

                        Text := CustomerList.GetSelectionFilter;
                        EXIT(TRUE);

                        UpdateCustomer;
                        rec.SETFILTER("Check Date", rec.GETFILTER("Date Filter"));
                        IF NOT Rec.FINDFIRST THEN
                            UpdateBalance;
                    end;

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field(ContractFilter; ContractFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Filter';
                    TableRelation = "Service Contract Header"."Contract No." WHERE("Contract Type" = CONST(Contract));

                    trigger OnValidate()
                    begin
                        ContractNoOnAfterValidate; //WIN325
                    end;
                }
                field(StatusFilter; StatusFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Status Filter';

                    trigger OnValidate()
                    begin
                        StatusOnAfterValidate; //WIN325
                    end;
                }
                field(PaymentMethodFilter; PaymentMethodFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method Filter';

                    trigger OnValidate()
                    begin
                        PaymentMethodOnAfterValidate //PDCCR
                    end;
                }
            }
            repeater(General)
            {
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the number of the account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document no. for this post-dated check journal.';

                    trigger OnAssistEdit()
                    begin
                        //WINPDC++
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                        //WINPDC--
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    Caption = 'Bal. Account No.';
                    ToolTip = 'Specifies the bank account No. where you want to bank the post-dated check.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the check No. for the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the post-dated check when it is supposed to be banked.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the currency code of the post-dated check.';
                    Visible = false;
                }
                field(Charges; Rec.Charges)
                {
                    ApplicationArea = All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Amount of the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this is an auto-generated field which calculates the LCY amount.';
                    Visible = false;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when we received the post-dated check.';
                }
                field("Replacement Check"; Rec."Replacement Check")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this is an indicator field that this check is a replacement for any earlier unusable check.';
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the comment for the transaction for your reference.';
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a default batch.';
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Reversal Reason Code"; Rec."Reversal Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Reversal Reason Comments"; Rec."Reversal Reason Comments")
                {
                    ApplicationArea = All;
                }
                field("Reversal Date"; Rec."Reversal Date")
                {
                    ApplicationArea = All;
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ApplicationArea = All;
                }
                field("Settlement Comments"; Rec."Settlement Comments")
                {
                    ApplicationArea = All;
                }
                field("Updated with Legal Dept"; Rec."Updated with Legal Dept")
                {
                    ApplicationArea = All;
                }
                field("PDC Due Date"; Rec."PDC Due Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("System Generated Date"; Rec."Contract Due Date")
                {
                    ApplicationArea = All;
                }
                field("System Generated Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Check"; Rec."Cancelled Check")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Police Case No."; Rec."Police Case No.")
                {
                    ApplicationArea = All;
                }
                field("Police Case"; Rec."Police Case")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("G/L Transaction No."; Rec."G/L Transaction No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Check Bounce"; Rec."Check Bounce")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Others)
            {
                Visible = false;
                field(Description2; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field(CustomerBalance; CustomerBalance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance (LCY)';
                    Editable = false;
                }
                field(LineCount; LineCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Count';
                    Editable = false;
                }
                field(LineAmount; LineAmount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part("Dimensions FactBox"; 9083)
            {
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
            group("&Account")
            {
                Caption = '&Account';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        CASE Rec."Account Type" OF
                            Rec."Account Type"::"G/L Account":
                                BEGIN
                                    GLAccount.GET(Rec."Account No.");
                                    PAGE.RUNMODAL(PAGE::"G/L Account Card", GLAccount);
                                END;
                            Rec."Account Type"::Customer:
                                BEGIN
                                    Customer.GET(Rec."Account No.");
                                    PAGE.RUNMODAL(PAGE::"Customer Card", Customer);
                                END;
                        END;
                    end;
                }
            }
            group("F&unction")
            {
                Caption = 'F&unction';
                Image = "Action";
                action("Drop Cheque")
                {
                    ApplicationArea = Basic, Suite;
                    Image = DisableBreakpoint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        UpdateChequeDropped;   //WINPDC
                    end;
                }
                action("Revoke Cheque")
                {
                    ApplicationArea = Basic, Suite;
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        UpdateStatusRevoked;   //WINPDC
                    end;
                }
                action("PDC Received")
                {
                    ApplicationArea = Basic, Suite;
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = QuoteVisible;

                    trigger OnAction()
                    begin
                        Rec.TestField("Check No.");//Win593
                        Rec.TestField("Bank Account");//Win593
                        UpdateStatusCollected; //WIN325
                        PdcReciepts();//WIN 586 --
                    end;
                }
                action("Notify to Legal Department")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF WORKDATE > ("Check Date" + 30) THEN BEGIN
                        //win315
                        CurrPage.SETSELECTIONFILTER(Rec);
                        /* MailCU.SendMailtoNotifyLegalDepart(Rec); *///WIN292
                        Rec.RESET;
                        Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                        Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325
                        //END;
                    end;
                }
                action(SuggestChecksToBank)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Suggest Checks to Bank';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SETVIEW('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                        BankDate := '..' + FORMAT(WORKDATE);
                        Rec.SETFILTER("Date Filter", BankDate);
                        Rec.SETFILTER("Check Date", Rec.GETFILTER("Date Filter"));
                        CurrPage.UPDATE(FALSE);
                        CountCheck := Rec.COUNT;
                        MESSAGE(Text002, CountCheck);
                    end;
                }
                action("Cheque Replacement")
                {
                    ApplicationArea = All;
                    Image = Reuse;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        IF Rec."Replacement Check" = FALSE THEN BEGIN
                            Rec.Status := Rec.Status::Replaced;
                            Rec.MODIFY
                        END ELSE
                            ERROR('This check already replaced.');
                        //win315--
                    end;
                }
                action("Cancel Check")
                {
                    ApplicationArea = All;
                    Image = Cancel;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        IF Rec."Cancelled Check" = FALSE THEN BEGIN
                            IF (Rec.Status = Rec.Status::Deposited) AND (Rec.Status <> Rec.Status::Reversed) AND (Rec.Status <> Rec.Status::Cancelled) THEN BEGIN
                                Rec.CALCFIELDS("Transaction No.");
                                Rec.TESTFIELD("Transaction No.");
                                ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                            END ELSE
                                ERROR('Status should be deposited');
                        END ELSE
                            ERROR('Check already cancelled');
                        //win315--
                    end;
                }
                action("Send for Police Case")
                {
                    ApplicationArea = All;
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++

                        Rec.Status := Rec.Status::"Send for Police Case";
                        Rec.MODIFY;
                        //win315--
                    end;
                }
                action("Police Cases")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        Rec.TESTFIELD("Police Case No.");
                        IF Rec."Police Case" = FALSE THEN BEGIN
                            Rec.Status := Rec.Status::"Police Case";
                            Rec."Police Case" := TRUE;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Already sent for Police case');
                        //win315--
                    end;
                }
                action("Closed Police Case")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        Rec.TESTFIELD("Applies-to Doc. No.");
                        Rec.TESTFIELD("Applies-to Doc. Type");

                        IF Rec."Closed Police Case" = FALSE THEN BEGIN
                            Rec.Status := Rec.Status::"Case Closed ";
                            Rec."Closed Police Case" := TRUE;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Police case already closed');
                        //win315--
                    end;
                }
                action("Court Case Details")
                {
                    ApplicationArea = All;
                    Image = Info;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Court Case Details";
                    Visible = false;
                }
                action("Check Bounces")
                {
                    ApplicationArea = All;
                    Image = Check;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        /*
                        PostDatedCheck1.RESET;
                        PostDatedCheck1.SETRANGE(PostDatedCheck1."Document No.",Rec."Document No.");
                        IF PostDatedCheck1.FINDFIRST THEN BEGIN
                        IF PostDatedCheck1."Check Bounce" = FALSE THEN BEGIN
                          IF (PostDatedCheck1.Status = PostDatedCheck1.Status::Deposited) AND (PostDatedCheck1.Status <> PostDatedCheck1.Status::Reversed) AND (PostDatedCheck1.Status <> PostDatedCheck1.Status::Cancelled) THEN BEGIN
                            PostDatedCheck1.CALCFIELDS("Transaction No.");
                            PostDatedCheck1.TESTFIELD("Transaction No.");
                            ReversalEntry.ReverseTransaction(PostDatedCheck1."Transaction No.");
                            {
                            PostDatedCheck1."Check Bounce" := TRUE;
                            PostDatedCheck1.MODIFY;
                            CurrPage.UPDATE(FALSE);
                            }
                          END ELSE
                            ERROR('Status should be deposited');
                        END ELSE
                          ERROR('Check %1 has been reversed already.',PostDatedCheck1."Check No.");
                        END;
                        
                        */

                        IF Rec."Check Bounce" = FALSE THEN BEGIN
                            IF (Rec.Status = Rec.Status::Deposited) AND (Rec.Status <> Rec.Status::Reversed) AND (Rec.Status <> Rec.Status::Cancelled) THEN BEGIN
                                Rec.CALCFIELDS("Transaction No.");
                                Rec.TESTFIELD("Transaction No.");
                                ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                            END ELSE
                                ERROR('Status should be deposited');
                        END ELSE
                            ERROR('Check %1 has been reversed already.', Rec."Check No.");
                        //win315--

                    end;
                }
                action("Show &All")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show &All';
                    Image = RemoveFilterLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SETVIEW('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                    end;
                }
                action("Apply &Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply &Entries';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';
                    Visible = QuoteVisible;

                    trigger OnAction()
                    begin
                        PostDatedCheckMgt.ApplyEntries(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(CreateCashJournal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Cash Journal';
                    Image = CheckJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        PDC: Record "Post Dated Check Line";
                    begin
                        //WINPDC++
                        IF Rec.Status = Rec.Status::"Revoke Cheque" THEN
                            ERROR('Cannot Create Cash Journal as cheque is revoked');
                        //WINPDC--
                        //TESTFIELD("Service Contract Type","Service Contract Type"::Internal); //WINS-394
                        IF CONFIRM(Text001, FALSE) THEN BEGIN
                            //PostDatedCheckMgt.Post(Rec);
                            CurrPage.SETSELECTIONFILTER(Rec);
                            PDC.COPY(Rec);
                            PostDatedCheckMgt.PostJournal(Rec, FALSE);
                            /*CustomerNo := '';
                            DateFilter := '';
                            ContractFilter := '';
                            StatusFilter   := StatusFilter::All;  //win315
                            RESET;*/
                        END;
                        Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                        Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325

                    end;
                }
                action("CreateCashJournal & Post")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Cash Journal && Post';
                    Image = CheckJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = QuoteVisible;

                    trigger OnAction()
                    var
                        PDC: Record "Post Dated Check Line";
                    begin
                        //WINPDC++
                        IF Rec.Status = Rec.Status::"Revoke Cheque" THEN
                            ERROR('Cannot Create Cash Journal & Post as cheque is revoked');
                        //WINPDC--
                        //TESTFIELD("Service Contract Type","Service Contract Type"::Internal); //WINS-394
                        IF CONFIRM(Text003, FALSE) THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(Rec);
                            PDC.COPY(Rec);
                            PostDatedCheckMgt.PostJournal(Rec, TRUE);
                            /*CustomerNo := '';
                            DateFilter := '';
                            ContractFilter := '';
                            StatusFilter   := StatusFilter::All;  //win315
                            RESET;*/
                        END;

                        Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                        //SETFILTER(Status,'<>%1|%2',Status::Deposited,Status::Received); //WIN325

                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Report';
                    Visible = QuoteVisible;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Post Dated Checks", TRUE, TRUE, Rec);
                    end;
                }
                action("Print Acknowledgement Receipt")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Acknowledgement Receipt';
                    Image = PrintAcknowledgement;
                    Visible = QuoteVisible;

                    trigger OnAction()
                    begin
                        PostDatedCheck.COPYFILTERS(Rec);
                        PostDatedCheck.SETRANGE("Account Type", Rec."Account Type");
                        PostDatedCheck.SETRANGE("Account No.", Rec."Account No.");
                        IF PostDatedCheck.FINDFIRST THEN;
                        REPORT.RUNMODAL(REPORT::"PDC Acknowledgement Receipt", TRUE, TRUE, PostDatedCheck);
                    end;
                }
            }
            /* action("PDC Reciepts")
             {
                 ApplicationArea = All;
                 Caption = 'PDC Reciepts';
                 Image = PostDocument;
                 // Visible = QuoteVisible;
                 Promoted = false;



                 trigger OnAction()
                 var
                     RecGenJournal: Record "Gen. Journal Line";
                     RecGenJournalLine: Record "Gen. Journal Line";
                     RecGenTemp: Record "Gen. Journal Template";
                     RecPDCLine: Record "Post Dated Check Line";
                     LineNo: Integer;
                 begin
                     //RecGenJournal.Reset();
                     //RecGenTemp.Get(RecGenTemp.Name);
                     //RecGenJournal.SetRange(RecGenJournal."Journal Template Name",RecGenTemp.Name);
                     RecPDCLine.Reset();
                     RecPDCLine.SetRange("Contract No.", Rec."Contract No.");
                     RecPDCLine.SetRange(RecPDCLine.Status, RecPDCLine.Status::Received);
                     if RecPDCLine.FindSet() then
                         repeat

                             RecGenJournalLine.SetRange("Journal Template Name", 'PAYMENT');
                             RecGenJournalLine.SetRange("Journal Batch Name", 'PDC');
                             if RecGenJournalLine.FindLast() then begin
                                 LineNo := RecGenJournalLine."Line No.";
                             end
                             else
                                 LineNo := 0;

                             RecGenJournal.Reset();
                             RecGenJournal.SetRange(RecGenJournal."Document No.", RecPDCLine."Document No.");
                             if not RecGenJournal.FindSet() then begin
                                 RecGenJournal.Init();
                                 RecGenJournal."Line No." := LineNo + 10000;
                                 RecGenJournal."Journal Template Name" := 'PAYMENT';
                                 RecGenJournal."Journal Batch Name" := 'PDC';
                                 RecGenJournal."Posting Date" := WorkDate();
                                 RecGenJournal."Document No." := RecPDCLine."Document No.";
                                 RecGenJournal."Account Type" := RecGenJournal."Account Type"::"G/L Account";
                                 RecGenJournal."Account No." := RecPDCLine."Account No.";
                                 RecGenJournal."Debit Amount" := RecPDCLine.Amount * -1;
                                 RecGenJournal."Bal. Account Type" := RecGenJournal."Bal. Account Type"::Customer;
                                 RecGenJournal."Bal. Account No." := RecPDCLine."Customer No.";
                                 RecGenJournal.Insert();


                                 // LineNo := RecGenJournal."Line No." + 10000;


                             end;




                         until RecPDCLine.Next() = 0;
                     Message('Reciepts Posted on General Journal');

                 end;
             }*/
            action("Cash Receipt Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
                Visible = QuoteVisible;
            }
            action("Customer Card")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Customer Card";
                Visible = false;
            }
        }
        area(reporting)
        {
            action("Post Dated Checks")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Dated Checks';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Post Dated Checks";
                Visible = QuoteVisible;
            }
            action("PDC Acknowledgement Receipt")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PDC Acknowledgement Receipt';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "PDC Acknowledgement Receipt";
                Visible = QuoteVisible;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        UpdateBalance;
        ServCntrH.RESET;
        ServCntrH.SETRANGE(ServCntrH."Contract No.", Rec."Contract No.");
        IF ServCntrH.FINDFIRST THEN BEGIN
            IF ServCntrH."Contract Type" = ServCntrH."Contract Type"::Quote THEN
                QuoteVisible := FALSE
            ELSE
                IF ServCntrH."Contract Type" = ServCntrH."Contract Type"::Contract THEN
                    QuoteVisible := TRUE;
        END;

        //Win593++
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            QuoteVisible := SalesHeader."Document Type" = SalesHeader."Document Type"::Order;
        //Win593--
    end;

    var
        CustomerNo: Code[20];
        Customer: Record 18;
        PostDatedCheck: Record "Post Dated Check Line";
        GLAccount: Record 15;
        CustomerList: Page "Customer List";
        PostDatedCheckMgt: Codeunit PostDatedCheckMgt;
        //ApplicationManagement: Codeunit "1"; //win292
        CountCheck: Integer;
        LineCount: Integer;
        CustomerBalance: Decimal;
        LineAmount: Decimal;
        DateFilter: Text[250];
        BankDate: Text[30];
        Text001: Label 'Are you sure you want to create Cash Journal Lines?';
        Text002: Label 'There are %1 check(s) to bank.';
        ContractFilter: Code[20];
        StatusFilter: Option " ",Received,Deposited,"Reversed/Cancelled",All;
        MailCU: Codeunit 17;
        Text003: Label 'Are you sure you want to create Cash Journal Lines & Post?';
        Text004: Label 'Do you want to send mail to Legal Department?';
        PaymentMethodFilter: Option " ",Cheque,Bank,Cash,All;
        GeneralLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
        ReversalCode: Code[20];
        PageReason: Page 259;
        ReasonCode: Record 231;
        ReversalComments: Text[100];


        //Commentbox: DotNet Interaction;//WIN292
        ReversalEntry: Record 179;
        PostDatedCheck1: Record "Post Dated Check Line";
        QuoteVisible: Boolean;
        ServCntrH: Record 5965;


    procedure UpdateBalance()
    begin
        LineAmount := 0;
        LineCount := 0;
        IF Customer.GET(Rec."Account No.") THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            CustomerBalance := Customer."Balance (LCY)";
        END ELSE
            CustomerBalance := 0;
        PostDatedCheck.RESET;
        PostDatedCheck.SETCURRENTKEY("Account Type", "Account No.");
        IF DateFilter <> '' THEN
            PostDatedCheck.SETFILTER("Check Date", DateFilter);
        PostDatedCheck.SETRANGE("Account Type", PostDatedCheck."Account Type"::Customer);
        IF CustomerNo <> '' THEN
            PostDatedCheck.SETRANGE("Account No.", CustomerNo);
        IF PostDatedCheck.FINDSET THEN BEGIN
            REPEAT
                LineAmount := LineAmount + PostDatedCheck."Amount (LCY)";
            UNTIL PostDatedCheck.NEXT = 0;
            LineCount := PostDatedCheck.COUNT;
        END;
    end;


    procedure UpdateCustomer()
    begin
        IF CustomerNo = '' THEN
            Rec.SETRANGE("Account No.")
        ELSE
            Rec.SETRANGE("Account No.", CustomerNo);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        //IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;//win292
        Rec.SETFILTER("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        Rec.SETFILTER("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure ContractNoOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF ContractFilter = '' THEN
            Rec.SETRANGE("Contract No.")
        ELSE
            Rec.SETRANGE("Contract No.", ContractFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StatusOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF StatusFilter = StatusFilter::All THEN
            Rec.SETRANGE(Status)
        ELSE
            Rec.SETRANGE(Status, StatusFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure UpdateStatusCollected()
    var
        PDC: Record "Post Dated Check Line";
        lText001: Label 'Do you want to update the Status as Collected?';
    begin
        //WIN325
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        PDC.SETRANGE(Status, PDC.Status::" ");
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::Received);


        /*FILTERGROUP(0);
        RESET;
        SETFILTER("Account Type",'Customer|G/L Account');
        SETFILTER(Status,'<>%1',Status::Deposited);*/

    end;

    //WIN 586 --
    local procedure PdcReciepts()
    var
        RecGenJournal: Record "Gen. Journal Line";
        RecGenJournalLine: Record "Gen. Journal Line";
        RecGenTemp: Record "Gen. Journal Template";
        RecPDCLine: Record "Post Dated Check Line";
        LineNo: Integer;
    begin
        //RecGenJournal.Reset();
        //RecGenTemp.Get(RecGenTemp.Name);
        //RecGenJournal.SetRange(RecGenJournal."Journal Template Name",RecGenTemp.Name);
        //WIN 586 --
        RecPDCLine.Reset();
        if Rec."Contract No." > '' then
            RecPDCLine.SetRange("Contract No.", Rec."Contract No.")
        else begin
            RecPDCLine.SetRange("Document Type", Rec."Document Type");
            RecPDCLine.SetRange("Document No.", Rec."Document No.");
        end;

        RecPDCLine.SetRange(RecPDCLine.Status, RecPDCLine.Status::Received);
        if RecPDCLine.FindSet() then
            repeat

                RecGenJournalLine.SetRange("Journal Template Name", 'PAYMENT');
                RecGenJournalLine.SetRange("Journal Batch Name", 'PDC');
                if RecGenJournalLine.FindLast() then begin
                    LineNo := RecGenJournalLine."Line No.";
                end
                else
                    LineNo := 0;

                RecGenJournal.Reset();
                RecGenJournal.SetRange(RecGenJournal."Document No.", RecPDCLine."Document No.");
                if not RecGenJournal.FindSet() then begin
                    RecGenJournal.Init();
                    RecGenJournal."Line No." := LineNo + 10000;
                    RecGenJournal."Journal Template Name" := 'PAYMENT';
                    RecGenJournal."Journal Batch Name" := 'PDC';
                    RecGenJournal."Posting Date" := WorkDate();
                    RecGenJournal."Document No." := RecPDCLine."Document No.";
                    RecGenJournal."Account Type" := RecGenJournal."Account Type"::"G/L Account";
                    RecGenJournal."Account No." := RecPDCLine."Account No.";
                    // RecGenJournal."Debit Amount" := RecPDCLine.Amount * -1;
                    RecGenJournal.Validate("Debit Amount", RecPDCLine.Amount * -1);
                    RecGenJournal."Bal. Account Type" := RecGenJournal."Bal. Account Type"::Customer;
                    RecGenJournal."Bal. Account No." := RecPDCLine."Customer No.";
                    RecGenJournal.Insert();


                    // LineNo := RecGenJournal."Line No." + 10000;


                end;




            until RecPDCLine.Next() = 0;
        Message('Reciepts Posted on General Journal');
        RecGenJournal.SendToPosting(Codeunit::"Gen. Jnl.-Post");//post from Gen journal line
        Message('Reciepts Posted from General Journal');
        //WIN 586 --
    end;


    local procedure UpdateStatusRevoked()
    var
        lText001: Label 'Do you want to update the Status as Revoke Cheque?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::"Revoke Cheque");
        //WINPDC--
    end;

    local procedure UpdateChequeDropped()
    var
        lText001: Label 'Do you want to Drop Cheque for the selected entries?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL("Cheque Dropped", TRUE);
        //WINPDC--
    end;

    local procedure PaymentMethodOnAfterValidate()
    begin
        //WINPDC++
        Rec.SETFILTER("Check Date", DateFilter);
        Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        IF PaymentMethodFilter = PaymentMethodFilter::All THEN
            Rec.SETRANGE("Payment Method")
        ELSE
            Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
        //WINPDC--
    end;
}

