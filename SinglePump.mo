model SinglePump
  Modelica.Fluid.Vessels.OpenTank tank(nPorts = 1, height = 1, crossArea = 3, redeclare package Medium = Modelica.Media.Examples.TwoPhaseWater, portsData(each diameter = 0.07, each height = 1))  annotation(
    Placement(transformation(origin = {-70, -8}, extent = {{-20, -20}, {20, 20}})));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow_start = 1, allowFlowReversal = true, p_ambient(displayUnit = "Pa"))  annotation(
    Placement(transformation(origin = {16, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(duration = 100, startTime = 200, height = 0.15, offset = 0.1)  annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.Boundary_pT boundary(nPorts = 1, redeclare package Medium = Modelica.Media.Examples.TwoPhaseWater, T = 293.15)  annotation(
    Placement(transformation(origin = {82, -48}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Machines.Pump pump(redeclare package Medium = Modelica.Media.Examples.TwoPhaseWater, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal(each displayUnit = "m3/h") = {8.333333333333334e-4, 8.611111111111111e-4}, head_nominal = {19, 18.9}), N_nominal = 5000, checkValve = true, V = 0.14)  annotation(
    Placement(transformation(origin = {24, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(displayUnit = "rpm")= 314.1592653589793)  annotation(
    Placement(transformation(origin = {16, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveCompressible fuelValve(redeclare package Medium = Modelica.Media.Examples.TwoPhaseWater, dp_nominal = 1e4, m_flow_nominal = 1, redeclare function valveCharacteristic = Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.linear, m_flow(start = 0.1), dp(start = 1e4))  annotation(
    Placement(transformation(origin = {-28, -48}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pump.port_b, boundary.ports[1]) annotation(
    Line(points = {{34, -48}, {72, -48}}, color = {0, 127, 255}));
  connect(constantSpeed.flange, pump.shaft) annotation(
    Line(points = {{26, -12}, {38, -12}, {38, -30}, {24, -30}, {24, -38}}));
  connect(ramp.y, fuelValve.opening) annotation(
    Line(points = {{-28, -30}, {-28, -40}}, color = {0, 0, 127}));
  connect(tank.ports[1], fuelValve.port_a) annotation(
    Line(points = {{-70, -28}, {-68, -28}, {-68, -48}, {-38, -48}}, color = {0, 127, 255}));
  connect(fuelValve.port_b, pump.port_a) annotation(
    Line(points = {{-18, -48}, {14, -48}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end SinglePump;
