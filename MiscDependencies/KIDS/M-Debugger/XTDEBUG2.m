XTDEBUG2 ;JLI/OAK_OIFO- ;10/23/09  15:46
 ;;7.3;TOOLKIT;**107**;Apr 25, 1995;Build 14
 ;;Per VHA Directive 2004-038, this routine should not be modified
 D EN^XTMUNIT("ZZUTXTD1")
 Q
 ;
STRTFOR ;(XTDEBARG,XTDEBLIN) ;
 N XTDEBFOR,XTDEBLOC,XTDEBUGI,XTDEBPC1,XTDEBLVL,XTDEBARG,XTDEBLIN,XTDEBVAR
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=$G(@XTDEBLOC@("LASTLVL"))
 M @XTDEBLOC@("LVL",XTDEBLVL+1,"XTDEBARG")=@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG")
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"CMND")=@XTDEBLOC@("LVL",XTDEBLVL,"CMND")
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"ROUTINE")=@XTDEBLOC@("LVL",XTDEBLVL,"ROUTINE")
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"LINE")=@XTDEBLOC@("LVL",XTDEBLVL,"LINE")
 M XTDEBARG=@XTDEBLOC@("LVL",XTDEBLVL+1,"XTDEBARG") S XTDEBLIN=@XTDEBLOC@("LVL",XTDEBLVL+1,"CMND")
 D DEBUG^XTMLOG("STRTFOR","XTDEBLVL,XTDEBLIN,XTDEBARG,"_$NA(@XTDEBLOC@("LVL")),1)
 ; setup for return to the calling line - remove, and set to get next line
 K @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS")
 S @XTDEBLOC@("LVL",XTDEBLVL,"CMND")="",^("ENTRY")=""
 S XTDEBLVL=XTDEBLVL+1
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL ; increment
 S @XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")="NEXTFOR"
 S @XTDEBLOC@("LVL",XTDEBLVL,"IN FOR")=1
 S XTDEBFOR=$G(@XTDEBLOC@("FORLVL"))+1
 S @XTDEBLOC@("FORLVL")=XTDEBFOR
 ;S @XTDEBLOC@("FOR",XTDEBFOR,"CMND")=XTDEBLIN
 I $P($G(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",1)),"=",2)="0:0" D
 . S @($P(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",1),"="))=0
 . S @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",1)=""
 M XTDEBARG=@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG")
 S XTDEBVAR=$P(XTDEBARG("ARGS",1),"=")
 I XTDEBVAR'="" D  ; set up each specified variable or range
 . F XTDEBUGI=2:1 Q:'$D(XTDEBARG("ARGS",XTDEBUGI))  S:XTDEBUGI>1 XTDEBARG("ARGS",XTDEBUGI)=XTDEBVAR_"="_XTDEBARG("ARGS",XTDEBUGI)
 . M @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG")=XTDEBARG
 . Q
 ;F XTDEBUGI=1:1 S XTDEBPC1=$P(XTDEBARG("ARGS",1),",",XTDEBUGI) Q:XTDEBPC1=""  S @XTDEBLOC@("FOR",XTDEBFOR,"ARGS",XTDEBUGI)=XTDEBPC1
 S @XTDEBLOC@("LVL",XTDEBLVL,"ARGS","CURR")=0
 ;
 G FORCMND
 ;
FORCMND ;
 N XTDEBFOR,XTDEBARG,XTDEBLOC,XTDEBLVL,XTDEBCMD,XTDEBCUR
 N XTDEBMAX,XTDEBINC,XTDEBSTR,XTDEBUGI,XTDEBUGX,XTDEBVAR
 N XTDEBDON,XTDEBCON,XTDEBLEV,XTDEBARX
 D INFO^XTMLOG("ENTERED FORCMND")
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBFOR=+$G(@XTDEBLOC@("FORLVL"))
 S XTDEBLVL=@XTDEBLOC@("LASTLVL")
 S XTDEBLEV=$NA(@XTDEBLOC@("LVL",XTDEBLVL))
 S XTDEBCUR=@XTDEBLEV@("ARGS","CURR")+1,@XTDEBLEV@("ARGS","CURR")=XTDEBCUR
 ;
 I '$D(@XTDEBLEV@("XTDEBARG","ARGS",XTDEBCUR)) G ENDFOR ; exit from FOR LOOP
 ;
 S XTDEBDON=0
 S XTDEBARG=@XTDEBLEV@("XTDEBARG","ARGS",XTDEBCUR)
 I $D(@XTDEBLEV@("XTDEBARG","ARGS",XTDEBCUR,"POSTCOND")) S XTDEBARG=XTDEBARG_":"_^("POSTCOND")
 S XTDEBCMD=$G(@XTDEBLEV@("XTDEBARG","CMND"))
 ; exit from LOOP
 D DEBUG^XTMLOG("FORCMND2","XTDEBCMD,XTDEBCUR,XTDEBARG,"_$NA(@XTDEBLOC@("LVL")),1)
 S XTDEBFOR=$NA(@XTDEBLEV@("FOR"))
 I $D(@XTDEBFOR@("START")) S XTDEBARG=""
 I '$D(@XTDEBFOR@("START")) S @XTDEBFOR@("VAR")=$P(XTDEBARG,"="),XTDEBARG=$P(XTDEBARG,"=",2)
 ; problem with parsing, cannot simply piece out everything with the "," command
 ; solution, avoid piece and actually parse. iterate over each char for the next ",", and also count ( and ) to equal out
 S XTDEBARX=0 F  Q:XTDEBARG=""  D
 . S XTDEBARX=XTDEBARX+1
 . S @XTDEBFOR@("START",XTDEBARX)=$$GETNARG(XTDEBARG) ; =$P(XTDEBARG,",")
 . S XTDEBARG=$$GETNARG(XTDEBARG,2,999) ; S XTDEBARG=$P(XTDEBARG,",",2,999)
NEXTSTRT ;
 ; following line uses naked global reference
 S XTDEBARX=$O(@XTDEBFOR@("START",0)) I XTDEBARX>0 S XTDEBARG=^(XTDEBARX) K ^(XTDEBARX) ; warning this line uses a naked global reference
 S @XTDEBFOR@("START")=$P(XTDEBARG,":")
 S @XTDEBFOR@("INCREMENT")=$S($P(XTDEBARG,":",2)=0:"",1:$P(XTDEBARG,":",2))
 S @XTDEBFOR@("MAX")=$P(XTDEBARG,":",3)
 S @XTDEBFOR@("NEW")=1
 S @XTDEBFOR@("CMND")=@XTDEBLEV@("CMND")
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL+1 ; MARK AS ONE LEVEL HIGHER
 D DEBUG^XTMLOG("FORCMND3",$NA(@XTDEBLOC@("LVL")),1)
 G NEXTFOR
 ;
NEXTFOR ;
 N XTDEBARG,XTDEBCMD,XTDEBFOR,XTDEBLOC,XTDEBLVL,XTDEBLEV,XTDEBINC
 N XTDEBSTR,XTDEBUGX,XTDEBSTR,XTDEBMAX,XTDEBVAR
 ; ZEXCEPT: XTDEBTRU - GLOBAL VARIABLE FOR $T
 D INFO^XTMLOG("ENTERED NEXTFOR")
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=@XTDEBLOC@("LASTLVL")-1
 K @XTDEBLOC@("LVL",XTDEBLVL+1)
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL
 S XTDEBLEV=$NA(@XTDEBLOC@("LVL",XTDEBLVL))
 S XTDEBFOR=$NA(@XTDEBLEV@("FOR"))
 I $D(@XTDEBLEV@("FOR QUIT")) D INFO^XTMLOG("LEAVING NEXTFOR DUE TO FOR QUIT") G ENDFOR
 S XTDEBVAR=@XTDEBFOR@("VAR"),XTDEBSTR=@XTDEBFOR@("START"),XTDEBINC=@XTDEBFOR@("INCREMENT"),XTDEBMAX=@XTDEBFOR@("MAX")
 S XTDEBUGX="S XTDEBMAX="_$S(XTDEBMAX="":"""""",1:XTDEBMAX) X XTDEBUGX
 D DEBUG^XTMLOG("NEXTFOR1","XTDEBVAR,XTDEBSTR,XTDEBINC,XTDEBMAX,"_XTDEBFOR,1)
 I XTDEBINC'="",XTDEBINC?1A.AN S XTDEBINC=@(XTDEBINC)
 I XTDEBINC="",XTDEBSTR=0,XTDEBVAR'="" S @(XTDEBVAR)=0,XTDEBVAR=""
 I XTDEBVAR'="",@XTDEBFOR@("NEW")'=1,XTDEBINC="" D INFO^XTMLOG("NEXTFOR TO FORCMND") G FORCMND ; only one value
 I XTDEBVAR'="",@XTDEBFOR@("NEW")'=1 S XTDEBUGX="S @(XTDEBVAR)=@XTDEBFOR@(""VAL"")+"_$S(XTDEBINC?1A.AN:"@(XTDEBINC)",1:"XTDEBINC") D DEBUG^XTMLOG("V1","XTDEBUGX") X XTDEBUGX S @XTDEBFOR@("VAL")=@XTDEBVAR
 I XTDEBVAR'="",@XTDEBFOR@("NEW")=1 S XTDEBUGX="S @(XTDEBVAR)="_$S(XTDEBSTR?1A.AN:"@(XTDEBSTR)",1:XTDEBSTR) D DEBUG^XTMLOG("V2","XTDEBUGX") X XTDEBUGX S @XTDEBFOR@("NEW")=0,@XTDEBFOR@("VAL")=@XTDEBVAR
 I XTDEBVAR'="" D DEBUG^XTMLOG("NEXTFOR2 - XTDEBVAR",XTDEBVAR)
 ; I XTDEBVAR'="",XTDEBMAX'="" I @XTDEBVAR>XTDEBMAX G FORCMND
 I XTDEBVAR'="",XTDEBMAX'="" S XTDEBUGX="I "_@(XTDEBVAR)_$S(XTDEBINC<0:"<",1:">")_$S(XTDEBMAX?.N:"XTDEBMAX",1:"@(XTDEBMAX)") D DEBUG^XTMLOG("V3","XTDEBUGX") X XTDEBUGX I $T S XTDEBTRU=1 G FORCMND
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"CMND")=@XTDEBFOR@("CMND")
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"ROUTINE")=@XTDEBLOC@("LVL",XTDEBLVL,"ROUTINE")
 S @XTDEBLOC@("LVL",XTDEBLVL+1,"LINE")=@XTDEBLOC@("LVL",XTDEBLVL,"LINE")
 S XTDEBLVL=XTDEBLVL+1,@XTDEBLOC@("LASTLVL")=XTDEBLVL
 S @XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")="NEXTFOR^XTDEBUG"
 S XTDEBCMD=$$GETCMND^XTDEBUG(.XTDEBARG,@XTDEBFOR@("CMND"))
 M @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG")=XTDEBARG
 S @XTDEBLOC@("LVL",XTDEBLVL,"CMND")=XTDEBCMD
 D INFO^XTMLOG("NEXTFOR TO COMMANDS")
 G COMMANDS^XTDEBUG1
 ;
ENDFOR ;
 N XTDEBLOC,XTDEBFOR,XTDEBLVL
 D INFO^XTMLOG("ENTERED ENDFOR")
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=@XTDEBLOC@("LASTLVL")
 S XTDEBFOR=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"FOR"))
 D DEBUG^XTMLOG("IN ENDFOR","XTDEBLVL,"_$NA(@XTDEBLOC@("LVL")),1)
 I $O(@XTDEBFOR@("START",0))>0 G NEXTSTRT
 S XTDEBLVL=XTDEBLVL-1
 K @XTDEBLOC@("LVL",XTDEBLVL+1)
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL
 I $G(@XTDEBLOC@("LVL",XTDEBLVL-1,"IN FOR")) D INFO^XTMLOG("ENDFOR TO NEXTFOR") G NEXTFOR
 D DEBUG^XTMLOG("ENDFOR TO NEXTENT")
 G NEXTENT^XTDEBUG
 ; FOLLOWING IS OVERFLOW FROM XTDEBUG1
QUERYNUM(VALUE) ;
 N LENGTH,X,XTDEBLOC
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S LENGTH=+$E(VALUE,2,99)-$L($G(@XTDEBLOC@("CONSOLE-OUT")))
 I LENGTH<1 S VALUE="" I 1
 E  S X="",$P(X," ",LENGTH)="",VALUE=""""_X_""""
 Q VALUE
 ;
READCMD ;
 N XTDEBXXX,XTDEBARG,XTDEBLOC,XTDEBLVL,XTDEBNUM
 ; ZEXCEPT: DTIME - SYSTEM VARIABLE
 ; ZEXCEPT: XTMUNIT - IF PRESENT IS NEWED AND DEFINED IN EN^XTMUNIT
 ; ZEXCEPT: XTDEBARG,XTDEBLOC,XTDEBLVL
 D DEBUG^XTMLOG("ENTERED READCMD","XTDEBARG",1) ; 070820
 S XTDEBLOC=$$GETGLOB^XTDEBUG(),XTDEBLVL=@XTDEBLOC@("LASTLVL")
 M XTDEBARG=@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG")
 S XTDEBNUM=$G(@XTDEBLOC@("LVL",XTDEBLVL,"ARGS","CURR")) ;+1 why is +1 here? causes this to blow up everytime
 I (XTDEBARG("ARGS",XTDEBNUM)="!")!(XTDEBARG("ARGS",XTDEBNUM)["""") D DEBUG^XTMLOG("READ GOING TO WRITE") G WRITECMD^XTDEBUG1
 D DEBUG^XTMLOG("READ 1")
 I $$BROKER^XWBLIB()&(IO=IO(0)) D  I '$D(XTMUNIT) D DEBUG^XTMLOG("READ GOING TO REASON") D REASON^XTDEBUG("READ",XTDEBNUM) Q
 . N XTDEBVAL,XTDEBTIM,XTDEBCHR
 . S XTDEBVAL=XTDEBARG("ARGS",XTDEBNUM)
 . I $E(XTDEBVAL)="*" S @XTDEBLOC@("LVL",XTDEBLVL,"READ-STAR")=1,^("READ-NUMCHARS")=1,XTDEBVAL=$E(XTDEBVAL,2,$L(XTDEBVAL))
 . ;S XTDEBTIM=$P(XTDEBVAL,":",2),XTDEBVAL=$P(XTDEBVAL,":") S:XTDEBTIM="" XTDEBTIM=DTIME S @XTDEBLOC@("LVL",XTDEBLVL,"READ-TIMEOUT")=$S(XTDEBTIM=+XTDEBTIM:XTDEBTIM,1:@XTDEBTIM)
 . S XTDEBTIM=$G(XTDEBARG("ARGS",XTDEBNUM,"POSTCOND")) S:XTDEBTIM="" XTDEBTIM=DTIME S @XTDEBLOC@("LVL",XTDEBLVL,"READ-TIMEOUT")=$S(XTDEBTIM=+XTDEBTIM:XTDEBTIM,1:@XTDEBTIM)
 . S XTDEBCHR=$P(XTDEBVAL,"#",2),XTDEBVAL=$P(XTDEBVAL,"#") I XTDEBCHR'="" S @XTDEBLOC@("LVL",XTDEBLVL,"READ-NUMCHARS")=$S(XTDEBCHR=+XTDEBCHR:XTDEBCHR,1:@XTDEBCHR)
 . S @XTDEBLOC@("LVL",XTDEBLVL,"READVAR")=XTDEBVAL
 . D DEBUG^XTMLOG("READ XTDEBVAL","XTDEBVAL")
 . Q
 I (IO'=IO(0))!('$$BROKER^XWBLIB()) D
 . S XTDEBXXX="R "_XTDEBARG("ARGS",XTDEBNUM) X XTDEBXXX
 . Q
 G FINISH^XTDEBUG1
 ;
 ;  TODO: Finish the following to unify determination of data display
CHEKDONE() ; returns an indicator of whether to display data to monitor (1=Yes,0=No)
 Q 0
 N XTDEBLOC,XTDEBLVL,XTDEBNUM,XTDEBPAS
 S XTDEBLOC=$$GETGLOB^XTDEBUG(),XTDEBLVL=@XTDEBLOC@("LASTLVL")
 I $G(@XTDEBLOC@("EXITTYPE"))="STEP",'$D(@XTDEBLOC@("REASONDONE")) S XTDEBPAS=1 D  I XTDEBPAS D REASON^XTDEBUG("CMND") S @XTDEBLOC@("REASONDONE")=1 Q 1
 . S XTDEBNUM=$G(@XTDEBLOC@("LVL",XTDEBLVL,"ARGS","CURR"))+1
 . I '$D(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",XTDEBNUM)) S XTDEBPAS=0
 . D DEBUG^XTMLOG("CHEKDONE","XTDEBPAS")
 . Q
 ; TODO: COMPLETE AND VALIDATE FOLLOWING LINE
 I $G(@XTDEBLOC@("NEWLINE"))=1,$G(@XTDEBLOC@("EXITTYPE"))="LINE",'$D(@XTDEBLOC@("REASONDONE"))
 ; TODO: ADD AT BREAKPOINT
 ; TODO: ADD CHANGE IN WATCHED VARIABLE
 Q 0
 ;
CHKARGS(XTDEBINP,XTDEBCNT) ; XTDEBINP passed by reference, returns CODE TO BE EXECUTED before the revised input line is executed
 N XTDEBCNT,XTDEBLIN,XTDEBV,XTDEBXXX,XTDEBUGI,XTDEBUJ,XTDEBLOC
 N XTDEBLVL,XTDEBUGJ
 S XTDEBLOC=$$GETGLOB^XTDEBUG(),XTDEBLVL=@XTDEBLOC@("LASTLVL")
 S XTDEBXXX=$$CHKARGS1(.XTDEBINP,.XTDEBCNT)
 S XTDEBLIN="" I XTDEBCNT>0 F XTDEBUGI=1:1:XTDEBCNT S XTDEBUGJ=XTDEBCNT-XTDEBUGI+1 S XTDEBLIN=XTDEBLIN_$S(XTDEBUGI>1:" ",1:"")_"S XTDEBV("_XTDEBUGJ_")="_$G(XTDEBLIN(XTDEBUGJ))
 S @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBINP")=XTDEBINP
 S @XTDEBLOC@("LVL",XTDEBLVL,"XTDEBLIN")=XTDEBLIN
 Q XTDEBLIN
 ;
CHKARGS1(XTDEBINP,XTDEBCNT) ;
 N XTDEBSRT,XTDEBEND,I,XTDEBCHR,XTDEBPAR,XTDEBQUO,XTDEBCN1
 N XTDEBL1,XTDEBP1
 S XTDEBLIN=""
 I $G(XTDEBCNT)="" S XTDEBCNT=0
 F I=1:1 Q:$E(XTDEBINP,I)=""  I (($E(XTDEBINP,I,I+1)="$$")!($E(XTDEBINP,I,I+1)="$S")) D
 . ;I $E(XTDEBINP,I-1)="=" Q  ; LEAVE THOSE WHICH ARE SIMPLY =$$ OR =$S
 . S XTDEBSRT=I
 . I $E(XTDEBINP,I,I+1)="$S" D  I 1
 . . S XTDEBQUO=0
 . . F I=I+1:1 Q:$E(XTDEBINP,I)=""  Q:$E(XTDEBINP,I)="("
 . . Q
 . ; JLI 091015 modified next line to add % as a valid character
 . ;E  S I=I+1 F  S I=I+1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  I XTDEBCHR'?1A,XTDEBCHR'?1N,XTDEBCHR'?1"^" Q
 . E  S I=I+1,LEN=0 F  S I=I+1,LEN=LEN+1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  S:XTDEBCHR="^" LEN=0 I '((XTDEBCHR?1"%")&(LEN=1)),XTDEBCHR'?1A,XTDEBCHR'?1N,XTDEBCHR'?1"^" Q
 . ;E  D
 . ;. N UPARROW S UPARROW=0
 . ;. S I=I+1,LEN=0 F  S I=I+1,LEN=LEN+1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  S:XTDEBCHR="^" UPARROW=1,I=I+1 Q:UPARROW  I '((XTDEBCHR?1"%")&(LEN=1)),XTDEBCHR'?1A,XTDEBCHR?1N Q
 . ;. ; 091023 following line modified to correct handling of LEN (not incremented before)
 . ;. ; I UPARROW S LEN=0 F  S I=I+1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  I '((XTDEBCHR?1"%")&(LEN=1)),XTDEBCHR'?1A,'((XTDEBCHR?1N)&(LEN>1)),XTDEBCHR'?1"^" Q
 . ;. I UPARROW S LEN=0 F  S I=I+1,LEN=LEN+1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  I '((XTDEBCHR?1"%")&(LEN=1)),XTDEBCHR'?1A,'((XTDEBCHR?1N)&(LEN>1)),XTDEBCHR'?1"^" Q
 . ;. Q
 . S XTDEBP1=0 I $E(XTDEBINP,I)="(" S XTDEBP1=I S XTDEBQUO=0 S XTDEBPAR=1 F I=I+1:1 S XTDEBCHR=$E(XTDEBINP,I) Q:XTDEBCHR=""  D  I XTDEBPAR=0 Q
 . . S:XTDEBCHR="""" XTDEBQUO=$S(XTDEBQUO=0:1,1:0) I XTDEBQUO=0 S:XTDEBCHR="(" XTDEBPAR=XTDEBPAR+1 S:XTDEBCHR=")" XTDEBPAR=XTDEBPAR-1
 . . Q
 . S XTDEBEND=I-$S(XTDEBP1=0:1,1:0)
 . I XTDEBLIN'="" S XTDEBLIN=" "_XTDEBLIN
 . S XTDEBCNT=XTDEBCNT+1
 . ;S XTDEBLIN="S XTDEBV("_XTDEBCNT_")="_$E(XTDEBINP,XTDEBSRT,XTDEBEND)_XTDEBLIN
 . S XTDEBLIN(XTDEBCNT)=$E(XTDEBINP,XTDEBSRT,XTDEBEND)
 . S XTDEBINP=$E(XTDEBINP,1,XTDEBSRT-1)_"XTDEBV("_XTDEBCNT_")"_$E(XTDEBINP,XTDEBEND+1,$L(XTDEBINP))
 . S XTDEBLIN=$E(XTDEBLIN(XTDEBCNT),3,$L(XTDEBLIN(XTDEBCNT)))
 . S XTDEBCN1=XTDEBCNT
 . D
 . . N XTDEBCN1,XTDEBP1
 . . S XTDEBP1=XTDEBLIN
 . . S XTDEBL1=$$CHKARGS1(.XTDEBP1,.XTDEBCNT)
 . . S XTDEBLIN=XTDEBP1
 . . Q
 . I XTDEBL1'="" S XTDEBLIN(XTDEBCN1)=$E(XTDEBLIN(XTDEBCN1),1,2)_XTDEBLIN
 . S I=XTDEBSRT-1
 . Q
 Q XTDEBLIN
 ;
PREPROCS ;
 N XTDEBLOC,XTDEBLVL,XTDEBLEV,XTDEBNUM,XTDEBRES,XTDEBAR1
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=@XTDEBLOC@("LASTLVL")
 S @XTDEBLOC@("LVL",XTDEBLVL,"ARGS","CURR")=@XTDEBLOC@("LVL",XTDEBLVL,"ARGS","CURR")-1
 S @XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")="COMMANDS^XTDEBUG"
 S XTDEBLEV=$NA(@XTDEBLOC@("LVL",XTDEBLVL))
 S XTDEBNUM=@XTDEBLEV@("ARGS","CURR")
 ;S @XTDEBLEV@("ARGS","CURR")=XTDEBNUM-1
 S @XTDEBLEV@("NEWED","XTDEBV")="" ; NEW THE XTDEBV VARIABLE
 ;
 S XTDEBLVL=XTDEBLVL+1
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL
 S XTDEBLEV=$NA(@XTDEBLOC@("LVL",XTDEBLVL))
 S @XTDEBLEV@("INTERNAL")=1
 S @XTDEBLEV@("CMND")=$$GETCMND^XTDEBUG(.XTDEBAR1,@XTDEBLOC@("LVL",XTDEBLVL-1,"PRE-PROCESS")_" Q")
 M @XTDEBLEV@("XTDEBARG")=XTDEBAR1
 K @XTDEBLOC@("LVL",XTDEBLVL-1,"PRE-PROCESS")
 S @XTDEBLOC@("LVL",XTDEBLVL,"PRE-PROCESS")=""
 S @XTDEBLEV@("ROUTINE")=$G(@XTDEBLOC@("LVL",XTDEBLVL-1,"ROUTINE"))
 S @XTDEBLEV@("LINE")=""
 ;W ! ZW @XTDEBLOC W !
 ;ZW @XTDEBLOC@("LVL")
 G STRTCMND^XTDEBUG
 ;W !,"STRTCMND",! ZW @XTDEBLOC@("LVL")
 ;D NEXT^XTDEBUG(.XTDEBRES,"RUN")
 ;W !,"NEXT",! ZW @XTDEBLOC@("LVL")
 ;W ! ZW XTDEBV
 ;W !,"X=",$G(X)
 Q
 ;
SETDOLT ; save current value of $T
 ; ZEXCEPT: XTDEBTRU - GLOBAL VARIABLE HOLDING VALUE OF $T
 S XTDEBTRU=$T
 Q
 ;
DOLRTEXT(ARG,ROUTINE) ; check $T code for no routine specified
 N TERM,TOKEN,VAR,A
 D INFO^XTMLOG("ENTRY","ARG,ROUTINE")
 F  Q:ARG'["$TEXT"  S ARG=$P(ARG,"$TEXT(")_"$T("_$P(ARG,"$TEXT(",2,99)
 ; GET ARGUMENT FOR $T, but permit subscripts as well
 S A(1)=$P(ARG,"$T("),A(2)=$P(ARG,"$T(",2,99),A(3)=$$NEXTTOKN^XTMRPAR2(A(2),.TOKEN,.TERM,")")
 D INFO^XTMLOG("VALUES","A",1)
 I TOKEN'["@",TOKEN["^",A(3)'["$T(" D INFO^XTMLOG("NORMAL","A",1) Q ARG
 ; check for $T(@variable)
 ;I $E(TOKEN,1)="@" S VAR=$E(TOKEN,2,$L(TOKEN)) I @VAR'["^" S VAR=VAR_"^"_ROUTINE Q A(1)_"$T(@"_VAR_")"_A(3)
 I TOKEN'["@",TOKEN'["^" S TOKEN=TOKEN_"^"_ROUTINE
 I TOKEN["@" S VAR=$E(TOKEN,2,$L(TOKEN)) D
 . I @VAR["^" S TOKEN=@VAR Q
 . S TOKEN=@VAR_"^"_ROUTINE
 . Q
 D INFO^XTMLOG("AGGREGATING","TOKEN,A",1)
 S ARG=A(1)_"$T("_TOKEN_")"_$S(A(3)["$T(":$$DOLRTEXT(A(3),ROUTINE),1:A(3))
 D INFO^XTMLOG("LEAVING","ARG")
 Q ARG
 ;
SETLGR ; save current value of last global reference, if not XTDEBUG-related
 ; ZEXCEPT: XTDEBLGR - GLOBAL VARIABLE
 N JUNK
 S JUNK=$$LGR^%ZOSV
 I JUNK'["^TMP(""XTDEBUG""" S XTDEBLGR=JUNK
 Q
 ;
RESETLGR ; reset last global reference to previous non XTDEBUG-related
 N JUNK
 ; ZEXCEPT: XTDEBLGR - GLOBAL VARIABLE
 I '$D(XTDEBLGR) S XTDEBLGR=$$LGR^%ZOSV
 I XTDEBLGR'["""""" S JUNK=$D(@XTDEBLGR) Q
 S JUNK=$O(@XTDEBLGR)
 Q
GETNARG(XTDEBEXP,XTDEBBGN,XTDEBEND)	; like $PIECE(str,",",n1,n2) but parses M code by ignoring ( and )
 ; sample input: I=1:1:$L(ABC,"^")
 N XTDEBCHR,XTDEBPOS,XTDEBPS1,XTDEBPS2,XTDEBLPC,XTDEBRPC
 S:'$D(XTDEBBGN) XTDEBBGN=1 S:'$D(XTDEBEND) XTDEBEND=XTDEBBGN
 S:XTDEBBGN=1 XTDEBPS1=1 S XTDEBPS2=$L(XTDEBEXP)
 S XTDEBLPC=0,XTDEBRPC=0
 F XTDEBPOS=1:1:$L(XTDEBEXP) D  I XTDEBEND=0 S XTDEBPS2=XTDEBPOS-1 Q
 . S XTDEBCHR=$E(XTDEBEXP,XTDEBPOS)
 . S:XTDEBCHR="(" XTDEBLPC=XTDEBLPC+1 S:XTDEBCHR=")" XTDEBRPC=XTDEBRPC+1
 . I (XTDEBCHR=",")&(XTDEBLPC=XTDEBRPC) D
 . . S XTDEBBGN=XTDEBBGN-1,XTDEBEND=XTDEBEND-1
 . . S:XTDEBBGN>0 XTDEBPS1=XTDEBPOS+1
 ; did it reach the last char?
 I XTDEBPOS=$L(XTDEBEXP) D
 . S:'$D(XTDEBPS1) XTDEBPS1=XTDEBPOS+1
 ; Q:XTDEBPOS=$L(XTDEBEXP) -1 Q XTDEBPOS+1
 Q $E(XTDEBEXP,XTDEBPS1,XTDEBPS2)
