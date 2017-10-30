namespace VideoVein
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.StartButton = new System.Windows.Forms.Button();
            this.comboBoxVideo = new System.Windows.Forms.ComboBox();
            this.VideoBox = new System.Windows.Forms.PictureBox();
            this.ComboFilter = new System.Windows.Forms.Button();
            this.filterBox = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.VideoBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.filterBox)).BeginInit();
            this.SuspendLayout();
            // 
            // StartButton
            // 
            this.StartButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.StartButton.Location = new System.Drawing.Point(12, 406);
            this.StartButton.Name = "StartButton";
            this.StartButton.Size = new System.Drawing.Size(633, 42);
            this.StartButton.TabIndex = 0;
            this.StartButton.Text = "&Start / Stop";
            this.StartButton.UseVisualStyleBackColor = true;
            this.StartButton.Click += new System.EventHandler(this.StartButton_Click);
            // 
            // comboBoxVideo
            // 
            this.comboBoxVideo.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.comboBoxVideo.FormattingEnabled = true;
            this.comboBoxVideo.Location = new System.Drawing.Point(12, 372);
            this.comboBoxVideo.Name = "comboBoxVideo";
            this.comboBoxVideo.Size = new System.Drawing.Size(633, 28);
            this.comboBoxVideo.TabIndex = 1;
            // 
            // VideoBox
            // 
            this.VideoBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.VideoBox.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.VideoBox.Location = new System.Drawing.Point(12, 13);
            this.VideoBox.Name = "VideoBox";
            this.VideoBox.Size = new System.Drawing.Size(633, 353);
            this.VideoBox.TabIndex = 2;
            this.VideoBox.TabStop = false;
            // 
            // ComboFilter
            // 
            this.ComboFilter.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ComboFilter.Location = new System.Drawing.Point(662, 406);
            this.ComboFilter.Name = "ComboFilter";
            this.ComboFilter.Size = new System.Drawing.Size(633, 42);
            this.ComboFilter.TabIndex = 3;
            this.ComboFilter.Text = "Filter";
            this.ComboFilter.UseVisualStyleBackColor = true;
            // 
            // filterBox
            // 
            this.filterBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.filterBox.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.filterBox.Location = new System.Drawing.Point(662, 12);
            this.filterBox.Name = "filterBox";
            this.filterBox.Size = new System.Drawing.Size(633, 353);
            this.filterBox.TabIndex = 4;
            this.filterBox.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1307, 460);
            this.Controls.Add(this.filterBox);
            this.Controls.Add(this.ComboFilter);
            this.Controls.Add(this.VideoBox);
            this.Controls.Add(this.comboBoxVideo);
            this.Controls.Add(this.StartButton);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.VideoBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.filterBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button StartButton;
        private System.Windows.Forms.ComboBox comboBoxVideo;
        private System.Windows.Forms.PictureBox VideoBox;
        private System.Windows.Forms.Button ComboFilter;
        private System.Windows.Forms.PictureBox filterBox;
    }
}

