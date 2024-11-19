
heightSpace(val)=>val*SizeConfig.heightMultiplier;
widthSpace(val)=>val*SizeConfig.widthMultiplier;
class SizeConfig{
  static double heightMultiplier = 0.0;
  static double widthMultiplier = 0.0;
  static final SizeConfig _singleton = SizeConfig._internal();

  factory SizeConfig(constraints) {
    heightMultiplier = constraints.maxHeight / 100;
    widthMultiplier = constraints.maxWidth / 100;
    return _singleton;
  }

  SizeConfig._internal();
}