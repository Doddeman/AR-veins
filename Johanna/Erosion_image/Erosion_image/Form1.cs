using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using AForge.Imaging.Filters;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Erosion_image
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            pictureBox1.Image = Image.FromFile("D:\\hair.jpg");
        }

        private static Bitmap GetArgbCopy(Image sourceImage)
        {
            Bitmap bmpNew = new Bitmap(sourceImage.Width, sourceImage.Height, PixelFormat.Format32bppArgb);


            using (Graphics graphics = Graphics.FromImage(bmpNew))
            {
                graphics.DrawImage(sourceImage, new Rectangle(0, 0, bmpNew.Width, bmpNew.Height), new Rectangle(0, 0, bmpNew.Width, bmpNew.Height), GraphicsUnit.Pixel);
                graphics.Flush();
            }

            return bmpNew;
        }

        private static Bitmap ApplyColorMatrix(Image sourceImage, ColorMatrix colorMatrix)
        {
            Bitmap bmp32BppSource = GetArgbCopy(sourceImage);
            Bitmap bmp32BppDest = new Bitmap(bmp32BppSource.Width, bmp32BppSource.Height, PixelFormat.Format32bppArgb);


            using (Graphics graphics = Graphics.FromImage(bmp32BppDest))
            {
                ImageAttributes bmpAttributes = new ImageAttributes();
                bmpAttributes.SetColorMatrix(colorMatrix);

                graphics.DrawImage(bmp32BppSource, new Rectangle(0, 0, bmp32BppSource.Width, bmp32BppSource.Height),
                                    0, 0, bmp32BppSource.Width, bmp32BppSource.Height, GraphicsUnit.Pixel, bmpAttributes);
            }
            bmp32BppSource.Dispose();

            return bmp32BppDest;
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

            ColorMatrix colorMatrix = new ColorMatrix(new float[][]
                        {
                            new float[]{.3f, .3f, .3f, 0, 0},
                            new float[]{.59f, .59f, .59f, 0, 0},
                            new float[]{.11f, .11f, .11f, 0, 0},
                            new float[]{0, 0, 0, 1, 0},
                            new float[]{0, 0, 0, 0, 1}
                        });

            Bitmap image = new Bitmap("D:\\hair.jpg");
            Bitmap image1 = ApplyColorMatrix(image, colorMatrix);
            image1.Save("D:\\grey_hair.jpg");

           

            pictureBox1.Image = image1;
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            Bitmap image = new Bitmap("D:\\grey_hair.jpg", PixelFormat.Format8bppIndexed);
            // create filter
            Erosion filter = new Erosion();
            // apply the filter
            filter.Apply(image);

            pictureBox2.Image = image;
        }
    }
}
