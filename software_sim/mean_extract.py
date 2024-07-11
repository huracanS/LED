import numpy as np
from moviepy.editor import VideoFileClip
from PIL import Image, ImageDraw
import struct
def extract_first_frame(video_path, output_image_path):
    """
    Extract the first frame from a video and save it as an image.

    Args:
    video_path (str): The path to the video file.
    output_image_path (str): The path where the extracted image will be saved.
    """
    # Load the video clip
    clip = VideoFileClip(video_path)
    
    # Get the first frame
    first_frame = clip.get_frame(0)
    
    # Save the first frame as an image
    Image.fromarray(first_frame).save(output_image_path)
    
    # Close the video clip
    clip.close()

def cal_recmean_on_image(image, rec_aeras):
    """
    Draw a rectangle on an image and save the result.
    """    
    mean_rgb_lst=[]
    for rec in rec_aeras:
        x1,y1,x2,y2 = rec[0],rec[1],rec[2],rec[3]
        ###计算部分#######
        region = image.crop((x1, y1, x2, y2)) # 提取矩形区域的像素
        region_array = np.array(region) # 将区域转换为numpy数组
        mean_rgb = np.mean(region_array, axis=(0, 1))# 计算RGB均值
        mean_rgb = [int(x) for x in mean_rgb]        # 将浮点数 RGB 值转换为整数。
        mean_rgb_lst.append(mean_rgb)
        ###显示部分#######
        draw  = ImageDraw.Draw(image)
        outline_color = (255, 0, 0)  # Red color for the outline
        draw.rectangle([x1, y1, x2, y2], outline=outline_color, width=3)
    return mean_rgb_lst
    

def show_mean_rgb(mean_rgb_lst,rec_aeras):
    """
    显示一个列表中 RGB 均值的图像。

    参数：
        mean_rgb_lst: 一个列表，其中每个元素都是一个包含三个浮点数的列表，表示 RGB 颜色值。
    """

    # 创建一个新图像。
    image = Image.new("RGB", (1920, 1080))
    draw =  ImageDraw.Draw(image)

    # 对于列表中的每个 RGB 均值，创建一个矩形并用该颜色填充。
    for i, mean_rgb in enumerate(mean_rgb_lst):
        # 创建一个矩形。
        x0 = rec_aeras[i][0]
        y0 = rec_aeras[i][1]
        x1 = rec_aeras[i][2]
        y1 = rec_aeras[i][3]
        
        rect = [(x0, y0), (x1,y1)]

        # 用颜色填充矩形。
        draw.rectangle(rect, fill=tuple(mean_rgb))

    # 显示图像。
    return image

def save_rgb_list_to_bin(rgb_list, file_path):
    """
    将一个RGB值的列表保存到一个二进制文件中。

    参数:
    rgb_list: 包含RGB值的列表，每个元素也是一个包含3个0-255范围内整数的列表。
    file_path: 输出的二进制文件路径。
    """
    # 打开一个二进制文件用于写入
    with open(file_path, 'wb') as bin_file:
        for rgb in rgb_list:
            # 将RGB值打包为二进制数据
            bin_data = struct.pack('BBB', *rgb)
            # 将二进制数据写入文件
            bin_file.write(bin_data)
from PIL import Image
import struct

def image_to_bin(image_path, bin_path):
    # 打开图像文件
    img = Image.open(image_path)
    
    # 确保图像是RGB格式
    img = img.convert('RGB')
    
    # 获取图像的宽度和高度
    width, height = img.size
    
    # 创建一个二进制文件用于写入
    with open(bin_path, 'wb') as bin_file:
        # 遍历每个像素
        for y in range(height):
            for x in range(width):
                # 获取当前像素的RGB值
                r, g, b = img.getpixel((x, y))
                # 将RGB值写入二进制文件
                bin_file.write(struct.pack('BBB', r, g, b))



def bin_to_image(bin_path, width, height):
    # 创建一个新的RGB图像
    img = Image.new('RGB', (width, height))
    
    # 打开二进制文件进行读取
    with open(bin_path, 'rb') as bin_file:
        # 遍历每个像素位置
        for y in range(height):
            for x in range(width):
                # 读取三个字节（R、G、B）
                rgb = bin_file.read(3)
                if not rgb:
                    raise ValueError("Binary file is too short for the given dimensions.")
                # 解析三个字节为RGB值
                r, g, b = struct.unpack('BBB', rgb)
                # 将RGB值设置到图像的对应像素
                img.putpixel((x, y), (r, g, b))
    
    img.show()


def read_rgb_from_bin(file_path):
    rgb_list = []

    with open(file_path, 'rb') as f:
        data = f.read()

    if len(data) != 48:
        raise ValueError("File does not contain exactly 48 bytes")

    for i in range(0, len(data), 3):
        r = data[i]
        g = data[i+1]
        b = data[i+2]
        rgb_list.append([r, g, b])

    return rgb_list




if __name__ == "__main__":
    '''-------------从1080p视频提取一个1080p图片--------------'''
    #已经提取过了
    #extract_first_frame('color.mp4', 'image.jpg')
    '''-----------------------------------------------------'''
    
    '''-------------读取图片---------------------------------'''
    image = Image.open('image.jpg')

    # 定义要计算均值的矩形区域
    rec_aeras=[
        [0,0,340,20],#aera 0
        [395,0,735,20],#aera 1
        [790,0,1130,20],#aera 2
        [1185,0,1525,20],#aera 3
        [1580,0,1920,20], #aera 4
        
        [0,25,20,365],#aera 5
        [1900,25,1920,365],#aera 6
        [0,370,20,710],#aera 7
        [1900,370,1920,710],#aera 8
        [0,715,20,1055],#aera 9
        [1900,715,1920,1055],#aera 10
        
        [0,1060,340,1080],#aera 11
        [395,1060,735,1080],#aera 12
        [790,1060,1130,1080],#aera 13
        [1185,1060,1525,1080],#aera 14
        [1580,1060,1920,1080], #aera 15
    ]
    '''-----------------------------------------------------'''
    
    '''-----------把图片转成bin并验证------------------------'''
    #-------------------------------------------------
    image_to_bin('image.jpg', './output/img.bin')   
    bin_to_image('./output/img.bin',1920,1080)#verify bin
    #-------------------------------------------------
    '''-----------------------------------------------------'''
    
    '''-----------算法计算均值分区并绘制分区框-----------------'''        
    mean_rgb_lst=cal_recmean_on_image(image, rec_aeras)
    image.save("image_add_rec.jpg")
    '''-----------------------------------------------------'''    


    '''-----------存储均值列表-------------------------------'''     
    # for rgb_lst in mean_rgb_lst:
    #     print(rgb_lst)
    # bin_file_path = 'rgb_means.bin'
    save_rgb_list_to_bin(mean_rgb_lst,'./output/algo_rgb_means.bin')
    '''-----------------------------------------------------'''     

    # rgb_rec_image=show_mean_rgb(mean_rgb_lst,rec_aeras)
    # #rgb_rec_image.show()
    # rgb_rec_image.save("image_mean_rec.jpg")
    '''-----------读取算法均值结果并存储图像---------------------------''' 
    algo_mean_rgb_lst=read_rgb_from_bin('./output/algo_rgb_means.bin')
    algo_rgb_rec_image = show_mean_rgb(algo_mean_rgb_lst,rec_aeras)
    algo_rgb_rec_image.save("algo_mean_rec.jpg")    
    '''--------------------------------------------------------------''' 
       
    '''-----------读取RTL均值结果并存储图像---------------------------''' 
    rtl_mean_rgb_lst=read_rgb_from_bin("./output/rtl_rgb_means.bin")
    rtl_rgb_rec_image = show_mean_rgb(rtl_mean_rgb_lst,rec_aeras)
    rtl_rgb_rec_image.save("rtl_mean_rec.jpg")
    '''--------------------------------------------------------------''' 





