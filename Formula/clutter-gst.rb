class ClutterGst < Formula
  desc "ClutterMedia interface using GStreamer for video and audio"
  homepage "https://developer.gnome.org/clutter-gst/"
  url "https://download.gnome.org/sources/clutter-gst/3.0/clutter-gst-3.0.24.tar.xz"
  sha256 "e9f1c87d8f4c47062e952fb8008704f8942cf2d6f290688f3f7d13e83578cc6c"

  bottle do
    sha256 "01ee56b08e394349a122c49946723ae3160fd929e69433ec217b147ef669772e" => :sierra
    sha256 "076425aafd980be4f68320ab5b9ea0168c4b46669a8ec4780483bda559c042ca" => :el_capitan
    sha256 "9a2970791ee1915aca45d49e265fdf7a4ff1730b5a371eda3b6c9e352141e13b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gdk-pixbuf"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-gtk-doc-html
    ]

    # the source code requires gdk-pixbuf but configure doesn't look for it
    ENV.append "CFLAGS", `pkg-config --cflags gdk-pixbuf-2.0`.chomp
    ENV.append "LIBS", `pkg-config --libs gdk-pixbuf-2.0`.chomp

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <clutter-gst/clutter-gst.h>

      int main(int argc, char *argv[]) {
        clutter_gst_init(&argc, &argv);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    clutter = Formula["clutter"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    json_glib = Formula["json-glib"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{clutter.opt_include}/clutter-1.0
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gst_plugins_base.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_lib}/gstreamer-1.0/include
      -I#{include}/clutter-gst-3.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gst_plugins_base.opt_lib}
      -L#{gstreamer.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lclutter-gst-3.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgstbase-1.0
      -lgstreamer-1.0
      -lgstvideo-1.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
