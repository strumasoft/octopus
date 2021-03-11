return [[
<html>
<head></head>
<body>
  {{message1}}
<br>
<b>{{message2}}</b>
<br>
  {{message3}}
<br>
{{
  _.t2({message = message1 .. message2 .. message3})
}}

{{= ddd = message1 .. message2 .. message3 }}=
ddd={{ddd}}

{{@ json }}@
{{ json.encode({a = 3, b = 2}) }}
</body>
</html>

----------------------------------------


]]