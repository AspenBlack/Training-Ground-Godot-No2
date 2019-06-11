using System;
using Godot;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NeuralNetworks;


/*This will need to add Score for each moment in time
 * Will all so need to implement the data as a List<>
 * so it can be accessed.
 * 
 * 
 * 
 * 
*/




namespace MoreDataTypes
{


    public class NodeData1
    {
        public int Index;
        public Node2D TheNode;

        public float Distance;
        

    }
    class DataType1
    {
        public double[] Inputs { get; set; }
        public double[] Outputs { get; set; }
    }

    class DataType2
    {
        public List<DataType1> DataArray { get; set; }
    }

    class DataType3
    {
        public int InSize { get; set; }
        public int OutSize { get; set; }
        public double [] Inputs { get; set; }
        public double[] Outputs { get; set; }
        public int ScoreSize { get; set; }
        public double[] Score { get; set; }

        public DataType3(int InSize, int OutSize,int ScoreSize)
        {
            this.InSize = InSize;
            this.OutSize = OutSize;
            this.ScoreSize = ScoreSize;
            Inputs = new double[InSize];
            Outputs = new double[OutSize];
            Score = new double[ScoreSize];
        }
    
        public DataType3(double[] Inputs, double[] Outputs, double[] Score)
        {
            this.Inputs = Inputs;
            this.OutSize = OutSize;
            this.Score = Score;
            InSize = Inputs.Length;
            OutSize = Outputs.Length;
            ScoreSize = Score.Length;
        }
    }
}