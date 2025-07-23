model FuelInjectionMk2
  inner Modelica.Fluid.System system(m_flow_start = 1)  annotation(
    Placement(transformation(origin = {51, 72}, extent = {{-17, -14}, {17, 14}})));
  Modelica.Fluid.Vessels.OpenTank fuelTank(nPorts = 1, height = 1, crossArea = 1.3, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, use_HeatTransfer = true, redeclare model HeatTransfer = Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.ConstantHeatTransfer(alpha0 = 11), use_portsData = true, portsData(each diameter = 0.07, each height = 1))  annotation(
    Placement(transformation(origin = {-82, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Fluid.Valves.ValveIncompressible fuelValve(dp_nominal = 1e4, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, redeclare function valveCharacteristic = Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.linear, m_flow_nominal = 1)  annotation(
    Placement(transformation(origin = {-60, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp fuelValveControl(duration = 100, startTime = 10, height = 0.9, offset = 0.1)  annotation(
    Placement(transformation(origin = {-60, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.Boundary_pT sink(nPorts = 1, p = 1e4, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, use_p_in = false, use_T_in = false)  annotation(
    Placement(transformation(origin = {82, -2}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Machines.Pump LowPressure(redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal = {1.4, 2, 2.5}, head_nominal = {60, 55, 48}), N_nominal = 8000)  annotation(
    Placement(transformation(origin = {-24, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed LowPressureController(w_fixed = 8000)  annotation(
    Placement(transformation(origin = {-24, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed HighPressureController(w_fixed = 2000) annotation(
    Placement(transformation(origin = {44, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Machines.Pump HighPressure(N_nominal = 2000, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal = {1.4, 2, 2.5}, head_nominal = {60, 55, 48})) annotation(
    Placement(transformation(origin = {44, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveIncompressible MidValve(redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, dp_nominal = 1e4, m_flow_nominal = 1, redeclare function valveCharacteristic = Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.linear)  annotation(
    Placement(transformation(origin = {10, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp fuelValveControl1(duration = 100, height = 0.9, offset = 0.1, startTime = 20) annotation(
    Placement(transformation(origin = {10, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(fuelTank.ports[1], fuelValve.port_a) annotation(
    Line(points = {{-82, 44}, {-82, -2}, {-70, -2}}, color = {0, 127, 255}));
  connect(fuelValveControl.y, fuelValve.opening) annotation(
    Line(points = {{-60, 17}, {-60, 5}}, color = {0, 0, 127}));
  connect(fuelValve.port_b, LowPressure.port_a) annotation(
    Line(points = {{-50, -2}, {-34, -2}}, color = {0, 127, 255}));
  connect(LowPressureController.flange, LowPressure.shaft) annotation(
    Line(points = {{-24, 18}, {-24, 8}}));
  connect(HighPressureController.flange, HighPressure.shaft) annotation(
    Line(points = {{44, 18}, {44, 8}}));
  connect(LowPressure.port_b, MidValve.port_a) annotation(
    Line(points = {{-14, -2}, {0, -2}}, color = {0, 127, 255}));
  connect(MidValve.port_b, HighPressure.port_a) annotation(
    Line(points = {{20, -2}, {34, -2}}, color = {0, 127, 255}));
  connect(HighPressure.port_b, sink.ports[1]) annotation(
    Line(points = {{54, -2}, {72, -2}}, color = {0, 127, 255}));
  connect(fuelValveControl1.y, MidValve.opening) annotation(
    Line(points = {{10, 15}, {10, 6}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end FuelInjectionMk2;
