Shader "Custom/StencilHole"
{

    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Geometry-1" "ForceNoShadowCasting" = "True" }
        LOD 200

        Stencil // всегда устанавливает в StencilBuffer значение 10
        {
            Ref 10
            Comp Always
            Pass Replace
        }

        CGPROGRAM

        #pragma surface surf NoLighting alpha // alpha позволяет объекту быть прозрачным

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        // модель позволяет никак не обрабатывать источники света и экономить ресурсы
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {

        }
        ENDCG
    }
    FallBack "Diffuse"
}


/*

Теги:

"RenderType" = "Transparent" — укажет, что отрисовку объекта надо делать в режиме
прозрачности, так как этот шейдер нужен для полностью прозрачного материала.

"Queue" = "Geometry-1" — укажет порядок отрисовки, в данном случае непосредственно
перед отрисовкой игровой геометрии. Это позволит записать необходимое значение в
StencilBuffer перед отрисовкой остального игрового мира.

"ForceNoShadowCasting" = "True" — укажет, что объект не должен отбрасывать тени. (Даже
прозрачные объекты в Unity могут отбрасывать тени.)


Модель LightingNoLighting

Необходима, т.к. не указывать никакой системы освещения нельзя. Функции
освещения начинаются со слова Lightning. Также есть ряд обязательных параметров, которые
должны передаваться в методе, которые необходимы, чтобы рассчитывать освещение объекта, но в
данном случае они нам не понадобятся. В методе просто копируются изначальные цвета
поверхности и возвращаются они в формате fixed4.

*/