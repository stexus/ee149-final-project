import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/widgets/display_received_data/display_received_data_widget.dart';
import '/widgets/strength_indicator/strength_indicator_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'device_page_model.dart';
export 'device_page_model.dart';

class DevicePageWidget extends StatefulWidget {
  const DevicePageWidget({
    Key? key,
    required this.deviceName,
    required this.deviceId,
    required this.deviceRssi,
    required this.hasWriteCharacteristic,
    bool? buttonToggle,
  })  : this.buttonToggle = buttonToggle ?? false,
        super(key: key);

  final String? deviceName;
  final String? deviceId;
  final int? deviceRssi;
  final bool? hasWriteCharacteristic;
  final bool buttonToggle;

  @override
  _DevicePageWidgetState createState() => _DevicePageWidgetState();
}

class _DevicePageWidgetState extends State<DevicePageWidget> {
  late DevicePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DevicePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _model.currentRssi = widget.deviceRssi;
        _model.toggle = widget.buttonToggle;
      });
      if (_model.toggle!) {
        _model.instantTimer = InstantTimer.periodic(
          duration: Duration(milliseconds: 1000),
          callback: (timer) async {
            await actions.sendPacket(
              BTDevicesStruct(
                name: widget.deviceName,
                id: widget.deviceId,
                rssi: widget.deviceRssi,
              ),
            );
          },
          startImmediately: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                    child: Text(
                      widget.deviceName!,
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Montserrat',
                            fontSize: 18.0,
                          ),
                    ),
                  ),
                  if (_model.currentRssi != null)
                    wrapWithModel(
                      model: _model.strengthIndicatorModel,
                      updateCallback: () => setState(() {}),
                      child: StrengthIndicatorWidget(
                        rssi: _model.currentRssi!,
                        color: valueOrDefault<Color>(
                          () {
                            if (_model.currentRssi! >= -67) {
                              return FlutterFlowTheme.of(context).success;
                            } else if (_model.currentRssi! >= -90) {
                              return FlutterFlowTheme.of(context).warning;
                            } else {
                              return FlutterFlowTheme.of(context).error;
                            }
                          }(),
                          FlutterFlowTheme.of(context).success,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: Text(
                  widget.deviceId!,
                  style: FlutterFlowTheme.of(context).labelSmall,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20.0,
                    buttonSize: 45.0,
                    icon: Icon(
                      Icons.bluetooth_disabled_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: 28.0,
                    ),
                    onPressed: () async {
                      await actions.disconnectDevice(
                        BTDevicesStruct(
                          name: widget.deviceName,
                          id: widget.deviceId,
                          rssi: _model.currentRssi,
                        ),
                      );
                      context.safePop();
                    },
                  ),
                ],
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You can send data to the connected device and receive data back from it.',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Montserrat',
                        lineHeight: 1.4,
                      ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: FFButtonWidget(
                    onPressed: () async {
                      setState(() {
                        _model.toggle = !_model.toggle!;
                      });
                    },
                    text: 'Toggle',
                    options: FFButtonOptions(
                      height: 36.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0x3F39D2C0),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: wrapWithModel(
                      model: _model.displayReceivedDataModel,
                      updateCallback: () => setState(() {}),
                      child: DisplayReceivedDataWidget(
                        device: BTDevicesStruct(
                          name: widget.deviceName,
                          id: widget.deviceId,
                          rssi: widget.deviceRssi,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
