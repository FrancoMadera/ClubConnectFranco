import 'package:flutter/material.dart';
import 'package:flutter_club_connect/service/noticiasservice.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/pages/public/detallenoticia.dart';
import 'package:flutter/services.dart'; // para SystemNavigator.pop()
import 'ajustes.dart';  // Ajustá la ruta según corresponda
import '/utils/styles.dart';


class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});


  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}


class _NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiasService _noticiasService = FirebaseNoticiasService();
  late Future<List<Noticia>> _noticiasFuture;


 @override
void initState() {
  super.initState();
  _noticiasFuture = _loadNoticias();
}

 Future<List<Noticia>> _loadNoticias() async {
  return _noticiasService.obtenerNoticias();
}

Future<void> _refreshNews() async {
  setState(() {
    _noticiasFuture = _loadNoticias();
  });
  await _noticiasFuture;
}

  ThemeMode _themeMode = ThemeMode.system;

  void _cambiarTema(ThemeMode modo) {
    setState(() {
      _themeMode = modo;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(
          'images/escudo.jpeg',
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () => _refreshNews(),
            tooltip: 'Refrescar Noticias',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: FutureBuilder<List<Noticia>>(
        future: _noticiasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }
          final noticias = snapshot.data ?? [];
          if (noticias.isEmpty) return _buildEmptyWidget();
          return RefreshIndicator(
            onRefresh: _refreshNews,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: noticias.length,
              itemBuilder: (context, index) => _buildNewsCard(noticias[index]),
            ),
          );
        },
      ),
    );
  }


  Widget _buildDrawer(BuildContext context) {
  final Color redColor = const Color(0xFFB71C1C);


  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: redColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'images/escudo.jpeg',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Club Atlético 9 de Julio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),


        // Club con dos subsecciones
        ExpansionTile(
          leading: Icon(Icons.account_balance, color: redColor),
          title: const Text(
            'Club',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          children: [
            _buildDrawerSubItem(
              icon: Icons.history,
              title: 'Historia',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/historia');
              },
            ),
            _buildDrawerSubItem(
              icon: Icons.location_on,
              title: 'Ubicación',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ubicacion');
              },
            ),
          ],
        ),


        // Fútbol con subsecciones anidadas
        ExpansionTile(
          leading: Icon(Icons.sports_soccer, color: redColor),
          title: const Text(
            'Fútbol',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          children: [


            // Fútbol Profesional
            ExpansionTile(
              title: const Text('Fútbol Profesional'),
              children: [
                _buildDrawerSubItem(
                  icon: Icons.article,
                  title: 'Noticias',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-profesional/noticias');
                  },
                ),
                _buildDrawerSubItem(
                  icon: Icons.people,
                  title: 'Plantel',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-profesional/plantel');
                  },
                ),
              ],
            ),


            // Fútbol Amateur
            ExpansionTile(
              title: const Text('Fútbol Amateur'),
              children: [
                _buildDrawerSubItem(
                  icon: Icons.article,
                  title: 'Noticias',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-amateur/noticias');
                  },
                ),
                _buildDrawerSubItem(
                  icon: Icons.people,
                  title: 'Plantel',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-amateur/plantel');
                  },
                ),
              ],
            ),


            // Fútbol Femenino
            ExpansionTile(
              title: const Text('Fútbol Femenino'),
              children: [
                _buildDrawerSubItem(
                  icon: Icons.article,
                  title: 'Noticias',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-femenino/noticias');
                  },
                ),
                _buildDrawerSubItem(
                  icon: Icons.people,
                  title: 'Plantel',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/futbol-femenino/plantel');
                  },
                ),
              ],
            ),


          ],
        ),

        //Contacto
        ListTile(
        leading: const Icon(Icons.contact_phone, color: Colors.orange),
        title: const Text('Contacto'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/contacto');
        },
      ),


    //Ajustes
    ListTile(
      leading: const Icon(Icons.settings),
      title: const Text('Ajustes'),
      onTap: () {
        Navigator.pop(context); // cierra el drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => AjustesScreen(
        currentThemeMode: _themeMode,
        onThemeChanged: _cambiarTema,
        )
        )
        );
      }
    ),
          //Cerrar App
          ListTile(
        leading: const Icon(Icons.exit_to_app, color: Colors.red),
        title: const Text(
          'Cerrar App',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          Navigator.pop(context); // cerrar el drawer

          // Mostrar mensaje de despedida
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('¡Gracias!'),
                content: const Text('Gracias por usar la app oficial del Club. ¡Te esperamos pronto!'),
                actions: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop(); // cerrar el diálogo
                    },
                  ),
                  TextButton(
                    child: const Text('Cerrar App'),
                    onPressed: () {
                      SystemNavigator.pop(); // cierra la app
                    },
                  ),
                ],
              );
            },
          );
        },
      ),

        
      
       /* // Más Deportes
        ListTile(
          leading: Icon(Icons.sports, color: redColor),
          title: const Text(
            'Más Deportes',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.
            pushNamed(context, '/mas-deportes');
          },
        ),*/
      ],
    ),
  );
}


  Widget _buildDrawerSubItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      leading: Icon(icon, size: 20),
      title: Text(title),
      onTap: onTap,
    );
  }


  Widget _buildNewsCard(Noticia noticia) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(noticia),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  noticia.imagenUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (noticia.categoria != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          noticia.categoria!.toUpperCase(),
                          style: Styles.sectionTitle.copyWith(fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      noticia.titulo,
                      style: Styles.newsTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${noticia.fecha.day}/${noticia.fecha.month}/${noticia.fecha.year}',
                      style: Styles.newsDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _navigateToDetail(Noticia noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleNoticiaScreen(noticia: noticia),
      ),
    );
  }


  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No hay noticias disponibles', style: Styles.newsDate),
          TextButton(onPressed: _refreshNews, child: const Text('Reintentar')),
        ],
      ),
    );
  }


  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Error al cargar noticias'),
          Text(error, style: const TextStyle(color: Colors.red)),
          TextButton(onPressed: _refreshNews, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}



