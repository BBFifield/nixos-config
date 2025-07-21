module.exports = {
  rules: {
    // Descending
    "no-descending-specificity": true,

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
      { ignorePseudoClasses: ["checked", "selected"] },
    ],
    "unit-no-unknown": true,
  },
};
