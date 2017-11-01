using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using AForge.Video;
using AForge.Video.DirectShow;


namespace VideoVein
{
    public partial class Form1 : Form
    {
        private FilterInfoCollection videoDevices;
        private VideoCaptureDevice videoSource; 

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            videoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);
            
            foreach (FilterInfo device in videoDevices)
            {
                comboBoxVideo.Items.Add(device.Name);
            }

            videoSource = new VideoCaptureDevice();
        }

        private void StartButton_Click(object sender, EventArgs e)
        {
            if (videoSource.IsRunning == true)
            {
                videoSource.Stop();
                VideoBox.Image = null;
                VideoBox.Invalidate();

            }
            else
            {
                videoSource = new VideoCaptureDevice(videoDevices[comboBoxVideo.SelectedIndex].MonikerString);
                // Set NewFrame Event handler
                videoSource.NewFrame += VideoSource_NewFrame;
                videoSource.Start();
            }
        }

        private void VideoSource_NewFrame(object sender, NewFrameEventArgs eventArgs)
        {
            Bitmap image = (Bitmap)eventArgs.Frame.Clone();
            VideoBox.Image = image;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
           if (videoSource.IsRunning)
            {
                videoSource.Stop();
            }
        }

    }
}
