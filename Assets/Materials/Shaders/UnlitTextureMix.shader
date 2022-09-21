Shader "Custom/UnlitTextureMix" // Custom - вкладка
{
    Properties //свойства шейдера
    {
    _Tex1 ("Texture1", 2D) = "white" {} // св-во для текстуры типа 2D
    _Tex2 ("Texture2", 2D) = "white" {} // св-во для текстуры типа 2D
    _MixValue("MixValue", Range(0,1)) = 0.5 // свойство типа float для модификатора смешивания (Range(0,1) вместо float)
    _Color("Main Color", COLOR) = (1,1,1,1) // свойство типа COLOR, задаётся цвет
    _Height("Height", Range(-1,20)) = -1 // переменная высоты типа float, влияет на силу изгиба
    }

    SubShader // основной код обработки изображения
    {
        Tags { "RenderType"="Opaque" } // тег показывает, что материал непрозрачный
        LOD 100 // уровень детализации (минимальный), отрисовуются только те шейдеры, значения LOD которых меньше указанных

        Pass // основная часть кода шейдера
        {
            CGPROGRAM // начало процедуры отрисовки в сабшейдере

            #pragma vertex vert // директива обрабатывает вершины, ссылается на метод vert
            #pragma fragment frag // директива обрабатывает фрагменты, ссылается на метод frag
            #include "UnityCG.cginc" // добавление ссылки на библиотеку UnityCG.cginc (функции преобразований и вычислений)

            sampler2D _Tex1; // текстура1
            float4 _Tex1_ST;

            sampler2D _Tex2; // текстура2
            float4 _Tex2_ST;
            
            float _MixValue; // параметр смешивания
            float4 _Color; // цвет, которым будет окрашиваться изображение
            float _Height; // сила изгиба
            
            struct v2f // структура преобразовует данные вершины в данные фрагмента (vertex to fragment)
            {
                float2 uv : TEXCOORD0; // UV-координаты вершины
                float4 vertex : SV_POSITION; // координаты вершины
            };

            v2f vert(appdata_full v) // метод обработки вершин, принимает переменную типа appdata_full, возвращает данные в виде структуры типа v2f
            {
                v2f result; // переменная result типа v2f
                
                v.vertex.y += _Height; // (-1 in inspector) - сдвиг объекта вверх (ось Y) на высоту _Height
                v.vertex.y += cos(0.45 * v.vertex.x);  // формула рассчета кривизны

                result.vertex = UnityObjectToClipPos(v.vertex); // метод UnityObjectToClipPos преобразует локальные координаты вершины в координаты в игровом мире
                result.uv = TRANSFORM_TEX(v.texcoord, _Tex1); // метода TRANSFORM_TEX находит UV-координаты
                return result;
            }

            // метод обработки пикселей (цвет пикселей умножается на цвет материала)
            fixed4 frag(v2f i) : SV_Target // метод принимает параметр в виде переменной типа v2f, а возвращать переменную типа fixed4
            {
                fixed4 color; // переменная, значение которой возвращает метод
                color = tex2D(_Tex1, i.uv) * _MixValue; // метод tex2D (UV-коор-ты фр-та, исходная текстура) получает цвет выбранной точки на текстуре 1
                color += tex2D(_Tex2, i.uv) * (1 - _MixValue); // получаем цвет выбранной точки на текстуре 2
                color = color * _Color; // дополнительно окрашивает изображение
                return color; // финальный цвет данного фрагмента
            }

            ENDCG // конец процедуры отрисовки в сабшейдере
        }
    }
}