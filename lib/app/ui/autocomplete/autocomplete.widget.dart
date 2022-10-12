import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


// ignore: must_be_immutable
class AutoCompleteCustom extends StatefulWidget {
  final String  Function(String )  validator;
  final void Function(Object)  onSelected;
  final void Function() onReset;
  final Iterable<String> Function(TextEditingValue) optionsBuilder;
  final String labelText;
  String  textoAyuda;
  String initialText="" ;
  Widget  icon;
  final bool   readOnly;
  final bool   enableInp  ;
  AutoCompleteCustom({
    Key  key,
     this.optionsBuilder,
      this.labelText,
     this.onSelected,
     this.validator,
      this.initialText,
    this.textoAyuda,
    this.icon,
     this.onReset,
    this.readOnly=false,
    this.enableInp=true
  }) : super(key: key);

  @override
  _AutoCompleteCustomState createState() => _AutoCompleteCustomState();
}

class _AutoCompleteCustomState extends State<AutoCompleteCustom> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        SchedulerBinding.instance.addPostFrameCallback((__) {
          if (widget.initialText  != '') {
            controller.text = widget.initialText ;
          }if (widget.initialText  != '.') {

          }
          else {
           // controller.clear();
          }
        });

        return TextFormField(
          validator: widget.validator,
          controller: controller,
          focusNode: focusNode,
          readOnly:widget.readOnly ,
          enabled:widget.enableInp ,
          onEditingComplete: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          decoration: InputDecoration(
            helperText: widget.textoAyuda,
            labelText: widget.labelText,
            icon: widget.icon,
            suffixIcon: IconButton(
              onPressed: () {


                if(widget.readOnly==false)
                {
                  controller.clear();
                  widget.onReset();
                }
              },
              icon:controller.text.length>0? Icon(Icons.clear): Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        );
      },
      //optionsMaxHeight:400.0 ,
      onSelected: widget.onSelected,
      optionsBuilder: widget.optionsBuilder,


    );
  }
}
