using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace Grayscale
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //read image
            Bitmap bmp = new Bitmap("D:\\katt.jpg");

            //copy bitmap

            Bitmap bmpgrey = new Bitmap("D:\\katt.jpg");
            Bitmap bmpneg = new Bitmap("D:\\katt.jpg");

            //load original image in picturebox1
            pictureBox1.Image = Image.FromFile("D:\\katt.jpg");

            //get image dimension
            int width = bmp.Width;
            int height = bmp.Height;

            //color of pixel
            Color p;

            //grayscale
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    //get pixel value
                    p = bmpgrey.GetPixel(x, y);

                    //extract pixel component ARGB
                    int a = p.A;
                    int r = p.R;
                    int g = p.G;
                    int b = p.B;

                    //find average
                    int avg = (r + g + b) / 3;

                    //set new pixel value
                    bmpgrey.SetPixel(x, y, Color.FromArgb(a, avg, avg, avg));
                }
            }

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    //get pixel value
                    p = bmpneg.GetPixel(x, y);

                    //extract pixel component ARGB
                    int a = p.A;
                    int r = p.R;
                    int g = p.G;
                    int b = p.B;

                    //find average
                    int nr = 255 - r;
                    int ng = 255 - g;
                    int nb = 255 - b;

                    //set new pixel value
                    bmpneg.SetPixel(x, y, Color.FromArgb(a, nr, ng, nb));
                }
            }

            //load grayscale image in picturebox2 and 3
            pictureBox2.Image = bmpgrey;

            pictureBox3.Image = bmpneg;

            //write the grayscale image
           // bmp.Save("D:\\Grayscale.png");
        }
    }
}
