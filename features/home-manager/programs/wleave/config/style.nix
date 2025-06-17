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
  }

  * {
    background-image: none;
    box-shadow: none;
  }

  window {
    background-color: rgba(0, 0, 0, 0.2);
  }

  button {
    border-color: @base02;
    color: @base08;
    background-color: @base02;
    border-style: solid;
    border-width: 1px;
    background-repeat: no-repeat;
    background-position: center;
    box-shadow:
      3px 10px 18px rgba(0, 0, 0, 0.2),
      6px 16px 22px rgba(0, 0, 0, 0.22),
      9px 22px 26px rgba(0, 0, 0, 0.26),
      13px 28px 33px rgba(0, 0, 0, 0.3);
  }
  button:hover {
    border-color: @base08;
    background-color: @base08;
  }
  button:active {
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3),
      4px 12px 10px rgba(0, 0, 0, 0.2) inset,
      7px 18px 14px rgba(0, 0, 0, 0.21) inset,
      10px 24px 18px rgba(0, 0, 0, 0.25) inset,
      14px 30px 24px rgba(0, 0, 0, 0.3) inset;
  }

  button:active label {
    font-size: 95px;
  }

  button:hover label {
    color: @base02;
    outline-style: none;
  }

''
