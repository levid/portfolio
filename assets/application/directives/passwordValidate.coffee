Application.Directives.directive "passwordValidate", ->
  restrict: "E"
  replace: true
  require: "ngModel"
  link: (scope, elm, attrs, ctrl) ->
    ctrl.$parsers.unshift (viewValue) ->
      scope.pwdValidLength = ((if viewValue and viewValue.length >= 8 then "valid" else `undefined`))
      scope.pwdHasLetter = (if (viewValue and /[A-z]/.test(viewValue)) then "valid" else `undefined`)
      scope.pwdHasNumber = (if (viewValue and /\d/.test(viewValue)) then "valid" else `undefined`)
      if scope.pwdValidLength and scope.pwdHasLetter and scope.pwdHasNumber
        ctrl.$setValidity "pwd", true
        viewValue
      else
        ctrl.$setValidity "pwd", false
        `undefined`

