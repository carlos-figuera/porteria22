import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/M_novedad.dart';
import 'package:intl/intl.dart';

class HistorialPageNovedad extends StatefulWidget {
  const HistorialPageNovedad({Key key}) : super(key: key);

  @override
  _HistorialPageNovedadState createState() => _HistorialPageNovedadState();
}

class _HistorialPageNovedadState extends State<HistorialPageNovedad> {
  List<MNovedad> _listNovedad;

  Solicitudes_http solicitudes_http;
  bool _carga = true;
  TextEditingController _buscarController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    _listNovedad = new List();
    gettData();
  }

  Widget textoItems({String name, String texto}) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      name,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: fontpParrafo,
                          fontWeight: FontWeight.w800,
                          color: textoGeneral),
                      textAlign: TextAlign.left,
                    )),
                Expanded(
                    child: Text(
                      texto,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: fontpParrafo,
                          fontWeight: FontWeight.w600,
                          color: textoSecundario),
                      textAlign: TextAlign.right,
                    )),
              ],
            )));
  }


  gettData() async {
    var snapshot = await solicitudes_http.getData("/api/novelties");
    _listNovedad = new List();
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;
        _listNovedad = data1.map((model) => MNovedad.fromJson(model,1 )).toList();
        print("Desde hasData  ${snapshot["data"]} ");
        print("Desde hasData  ${snapshot["codigo"]} ");
        print("Desde hasData  ${_listNovedad.length} ");
        _carga = false;

        setState(() {});

        // _controller.animateTo(_controller.position.maxScrollExtent, curve: Curves.linear, duration: Duration(milliseconds: 1500));
      } else {
        _carga = false;
        print("Desde cartelera  ${snapshot["codigo"]} ");
        print("Desde cartelera  ${snapshot.toString()} ");
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return _carga
        ? widget_Cargando()
        : Container(
        height: screenHeight,
        padding:   EdgeInsets.symmetric( horizontal:screenWidth* 0.01 ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  onChanged: (dato) {
                    if (dato.length > 0) {
                      _listNovedad.forEach((lisau) async {
                        if (lisau.createdAt.toString().toLowerCase().contains(dato)) {
                          print(lisau.createdAt.toString());
                        } else {
                          lisau.estado = 0;
                        }
                      });
                      setState(() {});
                    } else {
                      _listNovedad.forEach((lisau) async {
                        lisau.estado = 1;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search_sharp,
                        color: colorButton,
                      ),
                      labelText: "Buscar por Fecha",
                      hintText:"Buscar por Fecha",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Requerido*';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  controller: _buscarController,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _listNovedad.length,
                    itemBuilder: (context, position) {
                      _listNovedad.sort((b, a) => a.id.compareTo(b.id));
                      return _listNovedad[position].estado == 1 ?
                      Container(
                        color: Colors.white,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              //Carrousel de imagenes

                              _listNovedad[position].pictures.isNotEmpty
                                  ? Container(
                                   height:  screenHeight * 0.4,
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return   Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 2,
                                      ),
                                      child:  _listNovedad[position].picturesUrl.isNotEmpty
                                          ? Card(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          _listNovedad[position].picturesUrl[index] ,
                                          placeholder:
                                              (context, url) =>
                                              const Center(
                                                child:
                                                 CircularProgressIndicator(
                                                  backgroundColor:
                                                  Colors.white,
                                                ),
                                              ),
                                          errorWidget: (context,
                                              url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.contain,
                                          width: screenWidth,
                                        ),
                                        elevation: 0,
                                      ): const Center(
                                        child:
                                          CircularProgressIndicator(
                                          backgroundColor:
                                          Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: _listNovedad[position].picturesUrl.isEmpty ? 1 : _listNovedad[position].picturesUrl.length,
                                  viewportFraction: 1,
                                  scale: 0.8,
                                  pagination: const SwiperPagination(
                                      builder: DotSwiperPaginationBuilder(
                                          color: Colors.grey)),
                                  control: const SwiperControl(
                                      color: Colors.grey, size: 35),
                                  autoplay: false,
                                  onTap: (pos) {

                                  },
                                ),) : const SizedBox(),

                              //Descripcion y fecha


                              Container(
                                child: Padding(
                                  child: AutoSizeText(
                                    _listNovedad[position].description,
                                    maxLines: 8,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    softWrap: true,
                                    maxFontSize: 15,
                                    minFontSize: 13,

                                    textAlign:
                                    TextAlign.justify,
                                    wrapWords: true,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ),
                              Align(
                                child: Padding(
                                  child: AutoSizeText(
                                    DateFormat('yyyy-MM-dd HH:MM').format(_listNovedad[position].createdAt).toString(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    softWrap: true,
                                    maxFontSize: 16,
                                    minFontSize: 12,
                                    textAlign: TextAlign.right,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                alignment: Alignment.bottomRight,
                              )


                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          margin: const EdgeInsets.all(15),
                          elevation: 5,
                        ),
                      ) : const SizedBox();
                    }))
          ],
        ));
  }
}
