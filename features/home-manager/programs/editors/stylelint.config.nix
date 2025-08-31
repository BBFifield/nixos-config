package: plugin: ''
  module.exports = {
    "plugins": ["${plugin}/libexec/stylelint-high-performance-animation/node_modules/stylelint-high-performance-animation"],
    extends: ["${package}/lib/node_modules/stylelint-config-clean-order/warning"],
    rules: {
      // Performance
      "plugin/no-low-performance-animation-properties": true,

      // Duplicate
      "declaration-block-no-duplicate-properties": [
        true,
        { ignore: ["consecutive-duplicates-with-different-values"] },
      ],
      "font-family-no-duplicate-names": true,
      "no-duplicate-selectors": true,
      "no-duplicate-at-import-rules": true,

      // Empty
      "no-empty-source": true,

      // Invalid
      "color-no-invalid-hex": true,
      "function-calc-no-unspaced-operator": true,
      "string-no-newline": true,
      "syntax-string-no-invalid": true,

      // Irregular
      "no-irregular-whitespace": true,

      //Missing
      "custom-property-no-missing-var-function": true,
      /*The following pattern is considered a problem: a { font-family: Helvetica, Arial, Verdana, Tahoma; }*/
      /*The following pattern is not considered a problem: a { font-family: Helvetica, Arial, Verdana, Tahoma, sans-serif; }*/
      "font-family-no-missing-generic-family-keyword": true,

      // Unmatchable
      "selector-anb-no-unmatchable": true,

      // Unknown
      "selector-pseudo-class-no-unknown": [
        true,
        { ignorePseudoClasses: ["backdrop", "checked", "selected"] },
      ],
      "unit-no-unknown": true,
    },
  };
''
