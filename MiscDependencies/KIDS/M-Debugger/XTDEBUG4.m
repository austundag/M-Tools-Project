XTDEBUG4 ;JLI/OAK_OIFO- ;10/23/09  16:06
 ;;7.3;TOOLKIT;**107**;Apr 25, 1995;Build 14
 ;;Per VHA Directive 2004-038, this routine should not be modified
 D EN^XTMUNIT("ZZUTXTD1") W DUZ
 Q
 ; OPENTAG -  handles call to tag and setting up values for variables for the code following the tag
 ;     XTDEBAL1 - is the comma separated list of arguments as they appear in the code doing the calling
 ;                so variable names are correct, and so call by reference can be determined
 ;     XTDEBAL2 - is the comma separated list of arguments as they appear in the called TAG
OPENTAG(XTDEBAL1,XTDEBAL2) ;
 N XTDEBBYR,XTDEBFUN,XTDEBSTR,XTDEBARG,XTDEBPAR,XTDEBQUO,XTDEBDON,XTDEBGL2
 N XTDEBAR2,XTDEBARX,XTDEBCHR,XTDEBCHR,XTDEBGLO,XTDEBGL1,XTDEBLOC,XTDEBLVL
 N XTDEBARE,XTDEBNUM
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=+$G(@XTDEBLOC@("LASTLVL"))
 D DEBUG^XTMLOG("OPENTAG1","XTDEBAL1,XTDEBAL2,"_$NA(@XTDEBLOC@("LVL",XTDEBLVL)),1)
 D ADDLEVEL ; mark depth of call
 S XTDEBLVL=+$G(@XTDEBLOC@("LASTLVL"))
 S XTDEBGL1=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"XARGS")),XTDEBGL2=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"YARGS")),XTDEBGLO=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"CALL")) K @XTDEBGLO,@XTDEBGL1,@XTDEBGL2
 S XTDEBAL1=$G(XTDEBAL1),XTDEBAL2=$G(XTDEBAL2)
 S XTDEBNUM=0
LOOP ;
 D DEBUG^XTMLOG("IN LOOP","XTDEBAL1,XTDEBAL2")
 I XTDEBAL2="" D DEBUG^XTMLOG("OPENTAG2",$NA(@XTDEBLOC@("LVL",XTDEBLVL)),1) G SETNTRNL ;Q  ; done, don't worry if XTDEBAL1 isn't null as well - would give an immediate error
 S (XTDEBBYR,XTDEBFUN,XTDEBSTR)=0 I XTDEBAL1'="" D
 . I $E(XTDEBAL1)="." S XTDEBBYR=1,XTDEBAL1=$E(XTDEBAL1,2,$L(XTDEBAL1)) ; passed by reference
 . I $E(XTDEBAL1)="$" S XTDEBFUN=1 ; involves a function
 . I $E(XTDEBAL1)="""" S XTDEBSTR=1 ; total string value
 . Q
 D DEBUG^XTMLOG("IN LOOP","XTDEBBYR,XTDEBFUN,XTDEBSTR")
 S XTDEBPAR=0,XTDEBQUO=0,XTDEBDON=0
 S XTDEBARG="" F  Q:XTDEBAL1=""  S XTDEBCHR=$E(XTDEBAL1),XTDEBAL1=$E(XTDEBAL1,2,$L(XTDEBAL1)) D  Q:XTDEBDON
 . S:XTDEBCHR="(" XTDEBPAR=XTDEBPAR+1
 . S:XTDEBCHR="""" XTDEBQUO=XTDEBQUO+$S(XTDEBQUO=0:1,1:-1)
 . S:XTDEBCHR=")" XTDEBPAR=XTDEBPAR-1
 . I XTDEBCHR=",",XTDEBPAR=0,XTDEBQUO=0 S XTDEBDON=1 Q
 . S XTDEBARG=XTDEBARG_XTDEBCHR
 . Q
 S XTDEBNUM=XTDEBNUM+1
 ;
 D DEBUG^XTMLOG("IN LOOP1A","XTDEBARG")
 S XTDEBAR2=$P(XTDEBAL2,","),XTDEBAL2=$P(XTDEBAL2,",",2,99)
 ; external variable name, null otherwise
 S XTDEBARE=$S(XTDEBARG'?1A.AN:"",1:XTDEBARG)
 S @XTDEBGL1@(XTDEBNUM,"EXTNAME")=XTDEBARE
 S @XTDEBGL1@(XTDEBNUM,"EXTINPUT")=XTDEBARG
 I XTDEBARE'="" M @XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS")=@XTDEBARE
 I XTDEBARE="",XTDEBARG'="" S XTDEBARX="S @XTDEBGL1@(XTDEBNUM,""XTDEBARG"")="_XTDEBARG EXECUTE(XTDEBARX) ; X XTDEBARX --jspivey, this crashes when there is a naked global
 S @XTDEBGL1@(XTDEBNUM,"TYPE")=XTDEBBYR
 S @XTDEBGL1@(XTDEBNUM,"INTNAME")=XTDEBAR2
 G LOOP ; handles both single variables and functions
 ;
SETNTRNL ; set internal values after all are ready, in case of dependencies among calling arguments
 N XTDEBLOC,XTDEBLVL,XTDEBGL1,XTDEBNUM,XTDEBAR2,XTDEBARE,XTDEBARG
 N XTDEBARX,XTDEBBYR,XTDEBNUM
 S XTDEBLOC=$$GETGLOB^XTDEBUG()
 S XTDEBLVL=+$G(@XTDEBLOC@("LASTLVL"))
 S XTDEBGL1=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"XARGS"))
 F XTDEBNUM=0:0 S XTDEBNUM=$O(@XTDEBGL1@(XTDEBNUM)) Q:XTDEBNUM'>0  D
 . S XTDEBARE=$G(@XTDEBGL1@(XTDEBNUM,"EXTNAME")),XTDEBAR2=$G(@XTDEBGL1@(XTDEBNUM,"INTNAME"))
 . S XTDEBBYR=@XTDEBGL1@(XTDEBNUM,"TYPE")
 . M @XTDEBGL1@(XTDEBNUM,"INTNAME","VALS")=@XTDEBAR2
 . D DEBUG^XTMLOG("NEW OPEN","XTDEBNUM,"_$NA(@XTDEBGL1@(XTDEBNUM)),1)
 . K:XTDEBARE'="" @XTDEBARE K @XTDEBAR2
 . I XTDEBBYR M @XTDEBAR2=@XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS")
 . I 'XTDEBBYR,XTDEBARE'="",$D(@XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS"))#2 S @XTDEBAR2=$G(@XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS"))
 . I XTDEBARE="",XTDEBAR2'="" S XTDEBARX=$G(@XTDEBGL1@(XTDEBNUM,"XTDEBARG")) I XTDEBARX'="" D
 . . I $E(XTDEBARX)="$" S XTDEBARX="S "_XTDEBAR2_"="_XTDEBARX D DEBUG^XTMLOG("IN LOOP1","XTDEBARX") I XTDEBARG'="" X XTDEBARX
 . . I $E(XTDEBARX)'="$" S @XTDEBAR2=XTDEBARX
 . . Q
 . Q
 Q
 ;
 D DEBUG^XTMLOG("IN LOOP1A","XTDEBARG")
 S XTDEBAR2=$P(XTDEBAL2,","),XTDEBAL2=$P(XTDEBAL2,",",2,99)
 ; save off any variables related to our arguments name, restore on leave tag
 S @XTDEBGL1@(XTDEBAR2)=$S(XTDEBBYR:XTDEBARG,1:"")
 I XTDEBARG'="" X "M "_$NA(@XTDEBGLO@(XTDEBARG))_"=XTDEBARG"
 X "M "_$NA(@XTDEBGL2@(XTDEBAR2))_"=XTDEBAR2"
 ;D DEBUG^XTMLOG("REF1","XTDEBAR2,XTDEBAR8",1)
 ;I XTDEBAR8'=+XTDEBAR8,$E(XTDEBAR8)'="""" M @XTDEBGLO@(XTDEBAR2)=XTDEBAR8
 ;D DEBUG^XTMLOG("LOOP1B",$NA(@XTDEBGLO@(XTDEBARG))_","_$NA(@XTDEBGL1@(XTDEBAR2))_","_$NA(@XTDEBGL2@(XTDEBAR2)),1)
 I XTDEBARG'=XTDEBAR2 K @XTDEBAR2 I XTDEBAR2=XTDEBARG,$D(@XTDEBGLO@(XTDEBAR2))#2 S XTDEBARG=@XTDEBGLO@(XTDEBAR2) D DEBUG^XTMLOG("CHEK1","XTDEBARG",1)
 I XTDEBBYR D DEBUG^XTMLOG("XTDEBBYR") S XTDEBARX="M "_XTDEBAR2_"=@"_$NA(@XTDEBGLO@(XTDEBARG)) X XTDEBARX D DEBUG^XTMLOG("IN LOOPAX",$NA(@XTDEBLOC@("LVL"))_",XTDEBAR2,XTDEBARG,XTDEBARX,DIC,A",1) G LOOP
 D DEBUG^XTMLOG("IN LOOPA",$NA(@XTDEBLOC@("LVL"))_",XTDEBAR2,XTDEBARG",1)
 M @XTDEBGL2@(XTDEBARG)=XTDEBARG
 S XTDEBARX="S "_XTDEBAR2_"="_XTDEBARG
 D DEBUG^XTMLOG("IN LOOP1","XTDEBARX")
 I XTDEBARG'="" X XTDEBARX
 G LOOP ; handles both single variables and functions
 ;
LEAVETAG ;
 G POPLEVEL
 ;
NEWVARS(XTDEBVAR)	;
 ; TODO: HANDLE UNARGUMENTED NEW (SHOULDN'T HAPPEN)
 ; TODO: HANDLE EXCLUSIVE NEW
 N XTDEBGLO,XTDEBUGI,XTDEBVA1,XTDEBLVL,XTDEBUGJ,XTDEBVA2,XTDEBVA3,XTDEBSTR,XTDEBTMP
 S XTDEBGLO=$$GETGLOB^XTDEBUG(),XTDEBLVL=@XTDEBGLO@("LASTLVL"),XTDEBGLO=$NA(@XTDEBGLO@("LVL",XTDEBLVL,"NEWED")) ;K @XTDEBGLO
 S XTDEBVAR=$G(XTDEBVAR)
 Q:'$D(XTDEBVAR)
 ; save off any variables related to our arguments name, for restore on leave level, then kill
 ;   if a variable is newed twice in the same level, don't need to save off current value, the initial save will be restored
 ;F XTDEBUGI=1:1 S XTDEBVA1=$G(XTDEBVAR("ARGS",XTDEBUGI)) Q:XTDEBVA1=""  M:'$D(@XTDEBGLO@(XTDEBVA1)) @XTDEBGLO@(XTDEBVA1)=@XTDEBVA1 K @XTDEBVA1
 ; modified to handle a single set of comma separated arguments
 K ^TMP("LOLMAN","NEWVARS")
 ; Must iterate each element inside XTDEBVAR("ARGS",XTDEBUGI), take its @ ("indirect") value, which 99% of the time would just be its
 ; actual literal value. But for the cases where the newed var starts with "@", it will resolve to its actual var, or list of vars. These must
 ; be concated to a final string which will contains all the new'ed vars.
 ; input eg: XTDEBVAR("ARGS",1) = "AA,BB,@CC"                CC="DD,EE"  <-- seems that ("ARGS",2) is always null
 I $D(XTDEBVAR("ARGS",2)) S AASODAOSIDN=GASDBIASDUB ; force an error here
 S XTDEBVA1=XTDEBVAR("ARGS",1)
 ;iterate over each parm of NEW
 S XTDEBSTR=""
 S ^TMP("LOLMAN","NEWVARS","VA1")=XTDEBVA1 ;S:`$E(XTDEBVA2)="@" XTDEBSTR=XTDEBSTR_XTDEBVA2_"," S:$E(XTDEBVA2)="@" XTDEBSTR=XTDEBSTR_@XTDEBVA2_","
 F XTDEBUGI=1:1 S XTDEBVA2=$P(XTDEBVA1,",",XTDEBUGI) Q:XTDEBVA2=""  D
 . S ^TMP("LOLMAN","NEWVARS","VA2")=XTDEBVA2
 . S:$E(XTDEBVA2)'="@" XTDEBTMP=XTDEBVA2 S:$E(XTDEBVA2)="@" XTDEBTMP=@$E(XTDEBVA2,2,$L(XTDEBVA2))
 . ; S:$E(XTDEBVA2)'="@" XTDEBSTR=XTDEBSTR_XTDEBVA2_"," S:$E(XTDEBVA2)="@" XTDEBSTR=XTDEBSTR_@XTDEBVA2_","
 . S XTDEBSTR=XTDEBSTR_XTDEBTMP_","
 . S ^TMP("LOLMAN","NEWVARS","STR")=XTDEBSTR
 . Q
 ; S XTDEBSTR=$E(XTDEBSTR,1,$L(XTDEBSTR)-1)
 F XTDEBUGJ=1:1 S XTDEBVA3=$P(XTDEBSTR,",",XTDEBUGJ) Q:XTDEBVA3=""  S ^TMP("LOLMAN","NEWVARS","VA3")=XTDEBVA3 I $E(XTDEBVA3)'="$" M:'$D(@XTDEBGLO@(XTDEBVA3)) @XTDEBGLO@(XTDEBVA3)=@XTDEBVA3 K @XTDEBVA3
 Q
 ;
ADDLEVEL ;
 N XTDEBLOC
 S XTDEBLOC=$$GETGLOB^XTDEBUG(),@XTDEBLOC@("LASTLVL")=@XTDEBLOC@("LASTLVL")+1 ; increment
 Q
 ;
POPLEVEL ;
 N XTDEBLOC,XTDEBVAR,XTDEBTYP,XTDEBGLO,XTDEBLVL
 N XTDEBEXT,XTDEBGL1,XTDEBINT,XTDEBNUM,XTDEBUGI
 ; ZEXCEPT: XTDEBRTN  -- return value from intrinsic functions generated in NEXTENT
 ; clean and restore NEWed variables if necessary
 S XTDEBLOC=$$GETGLOB^XTDEBUG(),XTDEBLVL=@XTDEBLOC@("LASTLVL"),XTDEBGLO=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"NEWED"))
 S XTDEBGL1=$NA(@XTDEBLOC@("LVL",XTDEBLVL,"XARGS"))
 D DEBUG^XTMLOG("POPLEVEL1",$NA(@XTDEBLOC@("LVL")),1)
 S XTDEBVAR=""
 F  S XTDEBVAR=$O(@XTDEBGLO@(XTDEBVAR)) Q:XTDEBVAR=""  K @XTDEBVAR M @XTDEBVAR=@XTDEBGLO@(XTDEBVAR) K @XTDEBGLO@(XTDEBVAR)
 ; new section added 080506
 ;   first save any variables before killing off internal,
 F XTDEBNUM=0:0 S XTDEBNUM=$O(@XTDEBGL1@(XTDEBNUM)) Q:XTDEBNUM'>0  D
 . S XTDEBINT=@XTDEBGL1@(XTDEBNUM,"INTNAME")
 . M @XTDEBGL1@(XTDEBNUM,"INTNAME","FINAL")=@XTDEBINT
 . Q
 ;   now kill off internal variable names
 F XTDEBNUM=0:0 S XTDEBNUM=$O(@XTDEBGL1@(XTDEBNUM)) Q:XTDEBNUM'>0  D
 . S XTDEBINT=@XTDEBGL1@(XTDEBNUM,"INTNAME")
 . K @XTDEBINT
 . Q
 ;  and restore variables to external names
 F XTDEBNUM=0:0 S XTDEBNUM=$O(@XTDEBGL1@(XTDEBNUM)) Q:XTDEBNUM'>0  D
 . S XTDEBINT=@XTDEBGL1@(XTDEBNUM,"INTNAME"),XTDEBEXT=$G(@XTDEBGL1@(XTDEBNUM,"EXTNAME"))
 . I '@XTDEBGL1@(XTDEBNUM,"TYPE") D  Q
 . . M @XTDEBINT=@XTDEBGL1@(XTDEBNUM,"INTNAME","VALS")
 . . I XTDEBEXT'="" M @XTDEBEXT=@XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS")
 . . Q
 . I XTDEBINT'=XTDEBEXT M @XTDEBINT=@XTDEBGL1@(XTDEBNUM,"INTNAME","VALS")
 . M @XTDEBEXT=@XTDEBGL1@(XTDEBNUM,"INTNAME","FINAL")
 . Q
 ; DEBUG DEBUG
 F XTDEBNUM=0:0 S XTDEBNUM=$O(@XTDEBGL1@(XTDEBNUM)) Q:XTDEBNUM'>0  D
 . I '$D(@XTDEBGL1@(XTDEBNUM,"EXTNAME","VALS")) Q
 . S XTDEBEXT=$G(@XTDEBGL1@(XTDEBNUM,"EXTNAME"))
 . Q
 K @XTDEBGLO,@XTDEBGL1
 K @XTDEBLOC@("STK",XTDEBLVL)
 I $D(XTDEBRTN) D
 . D DEBUG^XTMLOG("","XTDEBRTN")
 . S XTDEBVAR=$G(@XTDEBLOC@("LVL",XTDEBLVL-1,"XTDEBVAR")) I XTDEBVAR'="" S @(XTDEBVAR)=XTDEBRTN
 . Q
 K @XTDEBLOC@("LVL",XTDEBLVL) ; <=======  Kill previous level data since we are leaving it
 S XTDEBLVL=XTDEBLVL-1
 S @XTDEBLOC@("LASTLVL")=XTDEBLVL ; decrement
 I $D(@XTDEBLOC@("LVL",XTDEBLVL,"PRE-PROCESS")),$G(@XTDEBLOC@("LVL",XTDEBLVL,"CMND"))="" G POPLEVEL ; skip over pre-process level
 D DEBUG^XTMLOG("POPLEVEL2",$NA(@XTDEBLOC@("LVL")),1)
 I XTDEBLVL=0,$G(@XTDEBLOC@("LVL",0,"CMND"))="" S XTDEBUGI=$$CHKWATCH^XTDEBUG() D REASON^XTDEBUG("DONE",1) Q
 G NEXTENT^XTDEBUG
 G NEXTENT^XTDEBUG
EXECUTE(XTDEBUGX) ;
 D RESETLGR^XTDEBUG X XTDEBUGX D SETDOLT^XTDEBUG,SETLGR^XTDEBUG
 Q