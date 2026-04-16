※ PowerPointがインストールされている必要がある

```
dotnet new console -n PPTParser
cd PPTParser
```

```Program.cs
using System;

class Program
{
    static void Main()
    {
        // PowerPointを起動
        Type powerpointType = Type.GetTypeFromProgID("PowerPoint.Application");
        dynamic powerpointApp = Activator.CreateInstance(powerpointType);
        
        // ファイルを開く
        string filePath = @"C:\Users\oe\PPTParser\test.pptx";
        dynamic presentation = powerpointApp.Presentations.Open(filePath);
        powerpointApp.WindowState = 2;//PPTが開いてしまうので最小化する
        
        Console.WriteLine($"ファイル名: {presentation.Name}");
        Console.WriteLine($"スライド数: {presentation.Slides.Count}");
        
        // Designs
        Console.WriteLine($"デザインテンプレート: {presentation.Designs.Count}個");
        
        for (int i = 1; i <= presentation.Designs.Count; i++)
        {
            dynamic design = presentation.Designs[i];
            Console.WriteLine($"  テンプレート {i}: {design.Name}");
        }
        
        // CustomLayouts(Designsの下にCustomLayoutsがある)
        Console.WriteLine($"\nレイアウト一覧:");
        dynamic layouts = presentation.SlideMaster.CustomLayouts;
        
        for (int i = 1; i <= layouts.Count; i++)
        {
            Console.WriteLine($"  レイアウト {i}: {layouts[i].Name}");
        }
        
        // 各スライドの情報
        for (int i = 1; i <= presentation.Slides.Count; i++)
        {
            dynamic slide = presentation.Slides[i];
            Console.WriteLine($"\nスライド {i}:");
            
            Console.WriteLine($"デザイン: {slide.Design.Name}");
            
            // 表題
            if (slide.Shapes.HasTitle == -1)
            {
                string title = slide.Shapes.Title.TextFrame.TextRange.Text;
                Console.WriteLine($"  表題: {title.Trim()}");
            }
            
            // 全ての図形を走査
            for (int j = 1; j <= slide.Shapes.Count; j++)
            {
                dynamic shape = slide.Shapes[j];
        
                // テキストボックス
                if (shape.HasTextFrame == -1)
                {
                    string text = shape.TextFrame.TextRange.Text;
                    if (!string.IsNullOrWhiteSpace(text))
                    {
                        Console.WriteLine($"    テキスト: {text.Trim().Replace("\r", " ")}");
                    }
                }
        
                // 画像
                if (shape.Type == 13)  // msoPicture
                {
                    Console.WriteLine($"    画像: {shape.Name}");
                }
            }
            
        }
        
        presentation.Close();
        powerpointApp.Quit();
    }
}
```
