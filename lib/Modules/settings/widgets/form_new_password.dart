import 'package:startickera/Data/Provider/mk_provider.dart';
import 'package:startickera/Data/Services/ftp_service.dart';
import 'package:startickera/Data/Services/navigator_service.dart';
import 'package:startickera/Modules/Session/session_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../Widgets/starlink/button.dart';
import '../../../Widgets/starlink/text_field.dart';

class FormNewPassWord extends StatefulWidget {
  const FormNewPassWord({super.key,required this.session});
  final SessionCubit session;

  @override
  State<FormNewPassWord> createState() => _FormNewPassWordState();
}

class _FormNewPassWordState extends State<FormNewPassWord> {
  String _newPass = "",_repeatPass = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Gap(12),
            StarlinkTextField(
              initialValue: "",
              onChanged: (str) {
                _newPass = str;
              },
              validator: (str){
                if(str == ""){
                  return "Ingrese una contraseña valida";
                }
                return null;
              },
              title: "Contraseña Nueva",
              textHint: "Contraseña Nueva",
            ),
            const Gap(8),
            StarlinkTextField(
              initialValue:  "",
              onChanged: (str) {
                _repeatPass = str;
              },
              validator: (str){
                if(str == ""){
                  return "Ingrese una contraseña valida";
                }
                if(_repeatPass != _newPass){
                  return "Las contraseñas no coinciden";
                }
                return null;
              },
              title: "Repita la Contraseña",
              textHint: "Repita la Contraseña",
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12.0,bottom: 8),
              child: StarlinkButton(
                  text: "Confirmar",
                  onPressed: ()async{
                    if (_formKey.currentState!.validate()){
                      MkProvider provider = MkProvider();
                      var r = await provider.changePass( widget.session.state.cfg!.password,_newPass ,_repeatPass);
                      if(r.statusCode <= 205){
                        widget.session.changeState( widget.session.state.copyWith(
                            configModel:  widget.session.state.cfg!.copyWith(password: _newPass)));
                        FtpService.initService(
                            address: widget.session.state.cfg!.host,
                            user: widget.session.state.cfg!.user,
                            pass: _newPass,
                        );
                      }
                      NavigatorService.goBack();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
