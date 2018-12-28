return [[
^hi-{{message}}$boy|
{{# array2
  this row will SHOW
}}#
{{# unknownArray
  this row will NOT SHOW
}}#
{{# array5
  this row will NOT SHOW TOO
}}#

{{# array
  {{## array[i]
    +{{array[i][ii]}}|
  }}##

  {{? logo == "$$"
    {{## array2
      _{{array2[ii]}}|
    }}##
  }}?
}}#

{{message}}

{{# array2
  -{{array2[i]}}|
}}#

usb<>{{logo}}

{{? logo == "$"
  www!
  
  {{?? logo == "$"
    x{{array2[2]}}
    
    {{# array2
      ={{array2[i]}}|
    }}#
  }}??
}}?

{{# array3
  {{i}} = {{array3[i]}}
}}#


]]