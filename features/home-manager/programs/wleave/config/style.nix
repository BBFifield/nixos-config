{
  config,
  pkgs,
}: ''
  @import url("colors.css");

  /* -- base styles -- */
  * {
    font-family:
      ${config.hm.theme.fonts.defaultMonospace},
      sans-serif;
    font-weight: normal;
    font-size: 100px;
    transition-duration: 0.2s;
    transition-timing-function: linear;
    transition-property:
      background-color,
      color,
      font-size,
      opacity,
      transform,
      box-shadow,
      -gtk-icon-transform;
    border: none;
    background-image: none;
    box-shadow: none;
  }

  window {
    background-color: rgba(0, 0, 0, 0.2);
  }

  button {
    color: var(--base08);
    background-color: var(--base02);
    margin: 1px 0px 0px 1px;
    box-shadow: var(--shadow-wide-base02);
  }
  button:hover {
    background-color: var(--base08);
    box-shadow: var(--shadow-wide-base08);
  }
  button:active,
  button:hover:active {
    background-color: var(--base02);
    margin: 0px;
    box-shadow: var(--shadow-inset-base02);
  }

  button:active label,
  button:hover:active label {
    color: var(--base08);
  }

  button:hover label {
    color: var(--base02);
    outline-style: none;
  }
''
