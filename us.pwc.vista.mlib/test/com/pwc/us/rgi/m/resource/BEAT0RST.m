BEAT0SRC ;ALB/CJM - AICS LIST CLINIC SETUP ; JUL 20,1993
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
SETUPS ; -- Lists forms/reports defined in print manager clinic setup
 ;
% NEW CLINIC,SETUP,NODE,COND,INTRFACE,PAGE,IBQUIT,IBHDT,X,Y,FORM,REPORT,NAME,VAUTD,DIVIS,NEWDIV,CNT,MULTI
 WRITE !!,"AICS Print Manager Clinic Setup Report",!!
 SET IBQUIT=0
 DO DIVIS GOTO:IBQUIT EXIT
 DO DEVICE GOTO:IBQUIT EXIT
 DO DQ
 GOTO EXIT
 IF $PIECE($ZVER,"/",2)<4 ZNSPACE X ZNSPACE CURUCI QUIT X
 QUIT
 ;
