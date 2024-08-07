import 'package:flutter/material.dart';
import 'movie_data.dart'; // 導入 movie_data.dart 檔案

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Movie(),
    );
  }
}

class Movie extends StatefulWidget {
  Movie({super.key});

  @override
  _MovieState createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  // 當前選中的電影類型
  MovieType _selectedMovieType = MovieType.Action;

  @override
  Widget build(BuildContext context) {
    // 定義一個 List 來存儲 MovieType 的實例
    final movieTypes = MovieType.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Colors.pink[100], // 設置 AppBar 的背景色為馬卡龍粉色
      ),
      body: Stack(
        children: [
          // 綠色區域
          Positioned.fill(
            top: 60, // 使下面的 Container 與頂部有一定間距
            child: Container(
              color: Colors.green[100], // 設置背景色為馬卡龍綠色
              child: Align(
                alignment: Alignment.topLeft, // 確保內容從左側開始對齊
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 確保 Row 根據子 Widget 的大小來設置寬度
                    children: movies[_selectedMovieType]?.map((movie) {
                      final imagePath = 'assets/movie/${_getMovieTypeName(_selectedMovieType)}/$movie.png';
                      return MovieItem(
                        imagePath: imagePath,
                        movieType: _getMovieTypeName(_selectedMovieType),
                        movieName: movie,
                        imageWidth: 200 / 6 * 4, // 設置圖片寬度
                      );
                    }).toList() ?? [],
                  ),
                ),
              ),
            ),
          ),
          // 黃色背景色的 Container
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 60,
              color: Colors.yellow[100], // 設置背景色為馬卡龍黃色
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 確保 Row 根據子 Widget 的大小來設置寬度
                  children: movieTypes.map((movieType) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMovieType = movieType;
                        });
                      },
                      child: Container(
                        width: 70,
                        height: 35,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[300], // 設置按鈕區域的背景色為馬卡龍藍色
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _getMovieTypeName(movieType),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 根據 MovieType 列舉返回相應的名稱
  String _getMovieTypeName(MovieType movieType) {
    switch (movieType) {
      case MovieType.Action:
        return 'Action';
      case MovieType.Comedy:
        return 'Comedy';
      case MovieType.Drama:
        return 'Drama';
      case MovieType.Horror:
        return 'Horror';
      case MovieType.SciFi:
        return 'SciFi'; // 確保與資料夾名稱一致
      default:
        return '';
    }
  }
}

class MovieItem extends StatelessWidget {
  final String imagePath;
  final String movieType;
  final String movieName;
  final double imageWidth;

  const MovieItem({
    Key? key,
    required this.imagePath,
    required this.movieType,
    required this.movieName,
    required this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // 設置左右間距
          width: imageWidth, // 設置 Container 寬度與圖片一致
          margin: const EdgeInsets.only(top: 8.0), // 設置圖片與上方的間距為8
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 確保 Column 內部的內容向左對齊
            children: [
              Container(
                width: imageWidth - 2 * 8.0, // 設置圖片寬度，減去左右間距
                height: 200, // 設置容器高度為 200
                margin: const EdgeInsets.only(bottom: 8.0), // 設置底部間距
                decoration: BoxDecoration(
                  color: Colors.transparent, // 取消圖片容器背景色
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // 可選，為圖片添加圓角
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // 填滿容器並保持比例
                    errorBuilder: (context, error, stackTrace) {
                      // 如果圖片加載錯誤，顯示一個錯誤提示
                      return Center(child: Text('Image not found'));
                    },
                  ),
                ),
              ),
              // 類型
              Text(
                movieType,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // 電影標題
              Flexible(
                child: Text(
                  movieName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // 限制最多兩行
                  overflow: TextOverflow.ellipsis, // 超出部分顯示省略號
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
