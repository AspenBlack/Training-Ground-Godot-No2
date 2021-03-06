/* 
First Attempt at implement Neural Network
by Craig Wroth
 */


//#define DebugA
#define DebugB


using Godot;
using System;
using NeuralNetworks;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;
using System.Linq;
using MoreDataTypes;





public class SmallBrain_II : Node
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    Node2D Parent = null;
    Godot.Collections.Dictionary<int, Node2D> ClosestFriend2 = null;
    Godot.Collections.Array<Node2D> ClosestFriend = null;
    Godot.Collections.Array<Node2D> ClosestFoe;
    Godot.Collections.Array<Node2D> Enviroment;
    Godot.Collections.Array<Node2D> NodeData;

    Godot.Collections.Array<Node2D> MyTestArray;
    float MyFloat1 = 0;
    string MyString = "";

    Godot.Collections.Dictionary<int, Node2D> MyDic;
    Godot.Collections.Dictionary MyDic2;
    

    BackPropogationNetwork MoveShootNet = new BackPropogationNetwork(18, 4, 18);
    double[] data_in = new double[18];
    double[] data_out = new double[4];
    float[] data_out3 = new float[4];
    int Acount = 0;

    System.Collections.Generic.IEnumerable <double> data_out2 = new double[4];
    System.Collections.Generic.List <NeuralNetworks.DataSet> TrainingData = new System.Collections.Generic.List <NeuralNetworks.DataSet>();
    NeuralNetworks.DataSet Training ;//= new  NeuralNetworks.DataSet();

    DataType3 FirstData = new DataType3(18,4,3);


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        Parent = (Node2D)GetParent();
        //GD.Print("Parent");
        //GD.Print(Parent);
    }

    public void think()
    {
        ClosestFriend = get_friends_informaion();
       
        ClosestFoe = get_foe_informaion();

        Enviroment = get_evironment_information();

        ClosestFriend2 = sort_distance(ClosestFriend);

        #if DebugA
        GD.Print("Network input Objects");
        GD.Print(ClosestFriend);
        GD.Print(ClosestFoe);
        GD.Print(Enviroment);
        GD.Print(ClosestFriend2);
        GD.Print(ClosestFoe[0].Position);
        GD.Print(ClosestFoe[0].Position.x); 
        GD.Print(ClosestFoe[0].Position.y);
        #endif

        #if DebugB
        GD.Print("+++ClosestFrient+++");
        GD.Print(ClosestFriend);
        GD.Print("---ClosestFrient2---");
        GD.Print(ClosestFriend2);
        #endif


        data_in[0] = ClosestFoe[0].Position.x;
        data_in[1] = ClosestFoe[0].Position.y;
        data_in[2] = ClosestFoe[1].Position.x;
        data_in[3] = ClosestFoe[1].Position.y;
        data_in[4] = ClosestFoe[2].Position.x;
        data_in[5] = ClosestFoe[2].Position.y;
        data_in[6] = ClosestFriend[0].Position.x;
        data_in[7] = ClosestFriend[0].Position.y;
        data_in[8] = ClosestFriend[1].Position.x;
        data_in[9] = ClosestFriend[1].Position.y;
        //data_in[10] = ClosestFriend[2].Position.x;
        //data_in[11] = ClosestFriend[2].Position.y;
        data_in[12] = Enviroment[0].Position.x;
        data_in[13] = Enviroment[0].Position.y;
        data_in[14] = Enviroment[1].Position.x;
        data_in[15] = Enviroment[1].Position.y;
        data_in[16] = Enviroment[2].Position.x;
        data_in[17] = Enviroment[2].Position.y;

        FirstData.Inputs[0] = ClosestFoe[0].Position.x;

        #if (DebugA)
        MyString ="";
        foreach(double Anumber in data_in)
        {
            MyString += Anumber.ToString() +",";
        }
        GD.Print("Objects Position Data");
        GD.Print(MyString);
        #endif

        normalize(data_in);
        MoveShootNet.ApplyInput(data_in);
        MoveShootNet.CalculateOutput();
        data_out2 = MoveShootNet.ReadOutput();
        data_out2 = denormalize(data_out2);


        

        data_out = new double[] {data_in[0],data_in[1] , data_in[0],data_in[1]};
        //normalize(data_out);
        
        Training = new NeuralNetworks.DataSet {Outputs = data_out, Inputs = data_in };
        //Training = new NeuralNetworks.DataSet() {(double[]) data_out2, Inputs = data_in };
        TrainingData.Add(Training);

        #if DebugA
        MyString ="";
        foreach(double Anumber in data_out2)
        {
            MyString += Anumber.ToString() +",";
        }
        GD.Print("Output of Network");
        GD.Print(MyString);
        

        //data_out = (double[]) data_out2;
        GD.Print("Has Current Move ",Parent.Get("CurrentMove"));
        GD.Print("Has Side ",Parent.Get("Side"));
        #endif

        Acount = 0 ;
        foreach(double Anumber in data_out2)
        {

            data_out3[Acount] = (float)Anumber;
            Acount++;
        }



        Parent.Set("CurrentMove",Parent.ToLocal(new Godot.Vector2(data_out3[2] ,data_out3[3] )));
        Parent.Set("CurrentTarget",new Godot.Vector2(data_out3[0] ,data_out3[1 ] ));

    }


    public void savedata()
    {
        #if DebugA
        GD.Print("Made it to the C# script");
        #endif
        NeuralNetwork.WriteDataSetToFile(TrainingData,"SomeData.xml");

    }

    //Ok save net works working now.  something wrong with the call not hitting so this work around.
    public void savenetwork()
    {
        #if DebugA
        GD.Print("Made it to the C# save Network script");
        #endif
        NeuralNetworks.NetworkData MyNet = MoveShootNet.GetNetworkData();
        
        //NeuralNetwork.SaveNetworkToFile(MyNet,"SomeNetwork.xml");  //not compatable with Mono 5.18 is compatable with 5.4
        System.Xml.Serialization.XmlSerializer Aserialiser = new  System.Xml.Serialization.XmlSerializer(typeof(NeuralNetworks.NetworkData)) ;
        //System.Xml.Serialization.XmlSerializer Aserialiser = new XmlSerializer(typeof(List<NeuralNetworks.LayerData>));
        //System.Xml.Serialization.XmlSerializer Bserialiser = new XmlSerializer(typeof(List<NeuralNetworks.ConnectionData>));
        try
        {
            //System.IO.TextWriter writer = new System.IO.StreamWriter("TheNeworkFileA.xml"); 
            System.IO.TextWriter writer = new System.IO.StreamWriter("SomeNetwork.xml"); 
            Aserialiser.Serialize(writer, MyNet);
            writer.Close();
        }
        catch
        {
            GD.Print("But Failed to Save DataA");//Not Normaly printed.
        }

        // try
        // {
        //     System.IO.TextWriter writer = new System.IO.StreamWriter("TheNeworkFileB.xml"); 
        //     Bserialiser.Serialize(writer, MyNet.Connections);
        //     writer.Close();
        // }
        // catch
        // {
        //     GD.Print("But Failed to Save DataB");
        // }


    }

    //Ok Load net works working now.  
    //But can not write to NumLayers because it is read only but cout rectreat Using simple constructer.
    public void loadnetwork()
    {
        int Anum ;
        NeuralNetworks.NetworkData MyNet = MoveShootNet.GetNetworkData();
        //NeuralNetworks.NetworkData MyNet2 = NeuralNetwork.ReadNetworkFromFile("SomeNetwork.xml"); // Not working some this about handing over to this funciton

        // NeuralNetworks.NetworkData MyNet2 = MoveShootNet.GetNetworkData();
        // System.Collections.Generic.IEnumerable <double> SomeBiases = new double[18];


        //This works which is lucky
        if (System.IO.File.Exists("SomeNetwork.xml"))
        {
            try
            {
                System.Xml.Serialization.XmlSerializer Aserialiser = new XmlSerializer(typeof(NeuralNetworks.NetworkData));
                System.IO.FileStream Astream = new System.IO.FileStream("SomeNetwork.xml",System.IO.FileMode.Open);
                MyNet = (NeuralNetworks.NetworkData)Aserialiser.Deserialize(Astream);
                Astream.Close();
            }
            catch
            {
                GD.Print("But Failed to Load File");//Not Normaly printed.
            }
        }
        else GD.Print("But Failed to Find File");//Not Normaly printed.

        // //MoveShootNet = new BackPropogationNetwork(MyNet2);
        //MoveShootNet.Layers[0].SetValues(MyNet.Layers[0].Bias);

        MoveShootNet.Layers = new NeuralNetworks.Layer[MyNet.Layers.Count];
        foreach (NeuralNetworks.LayerData ld in MyNet.Layers)
        {
            MoveShootNet.Layers[MyNet.Layers.IndexOf(ld)] = new NeuralNetworks.Layer(MyNet.Layers.IndexOf(ld), ld.NumNeuron, ld.ActType, ld.Bias);
        }

        foreach (ConnectionData cd in MyNet.Connections)
            {
                MoveShootNet.Layers[cd.From.Layer].Neurons[cd.From.Node].AddConnection(MoveShootNet.Layers[cd.To.Layer].Neurons[cd.To.Node], true, cd.Weight);
            }

        MoveShootNet.InputIndex = MyNet.InputLayerId;
        MoveShootNet.OutputIndex = MyNet.OutputLayerId;

        // SomeBiases = MyNet.Layers[0].Bias;
        // Anum = MyNet.Layers[0].Bias.Count;
        // Anum = SomeBiases.Count();
        // GD.Print("Anum is ",(Anum));
        // GD.Print("Bias is ",(SomeBiases));

        //MoveShootNet = new NeuralNetworks.BackPropogationNetwork(MyNet); // Not working heap miss alinment ?
    }




    public void trainnetwork()
    {
        #if DebugA
        GD.Print("Training Now");
        #endif
        MoveShootNet.BatchBackPropogate(TrainingData.ToArray(), 10, 0.4, 0.2);
    }

    public Godot.Collections.Dictionary<int, Node2D> sort_distance(Godot.Collections.Array<Node2D> SomeNodes)
    {
        
        int ACounter = 0;
        MyDic = new Godot.Collections.Dictionary<int, Node2D>();
        Godot.Collections.Dictionary<int, NodeData1> ADic =  new Godot.Collections.Dictionary<int, NodeData1>();
        NodeData1 TestData = new NodeData1 {Index = 1,TheNode = Parent, Distance = 1};
        SortedList<double, Node2D> MyList = new SortedList<double, Node2D>();
        double Distance = 0;
        Vector2 VDistance;

        foreach ( Node2D TheNode in SomeNodes)
        {
            

            VDistance = Parent.ToLocal(TheNode.Position);
            Distance = VDistance.LengthSquared();
            AddNode:
            try
            {
                MyList.Add(Distance,TheNode);
            }
            catch
            {
                Distance = Distance + 0.1;
                goto AddNode;
            }
            

        }

        foreach (KeyValuePair<double, Node2D> Anode in MyList)
        {
            ACounter++;
            MyDic.Add(ACounter,Anode.Value);

        }
        

        return MyDic;
    }

    public Godot.Collections.Array<Node2D> get_friends_informaion()
    {
        string Theside = "";
        Godot.Collections.Array SomeNodes = null;
        Theside = (string) Parent.Get("Side");
        SomeNodes = GetTree().GetNodesInGroup(Theside);

        return ArrayNodeto2D(SomeNodes);
    }


    public Godot.Collections.Array<Node2D> get_foe_informaion()
    {
        //Node Anode;
        string Theside = "";
        Theside = (string) Parent.Get("Side");
        Godot.Collections.Array<Node2D> SomeNodes = new Godot.Collections.Array<Node2D>();
        Godot.Collections.Array SomeOtherNodes = null;
        if (Theside == "BlueBots")
        {
            SomeOtherNodes = GetTree().GetNodesInGroup("RedBots");
        }
        else 
        {
            SomeOtherNodes = GetTree().GetNodesInGroup("BlueBots");
        }
        foreach (Node Anode in SomeOtherNodes)
        {
            SomeNodes.Add((Node2D)Anode);
        }

        return SomeNodes;
    }

    public Godot.Collections.Array<Node2D> get_evironment_information()
    {
        Godot.Collections.Array SomeNodes = null;
        SomeNodes = GetTree().GetNodesInGroup("Environment");

        return ArrayNodeto2D(SomeNodes);
    }


    public Godot.Collections.Array<Node2D> ArrayNodeto2D(Godot.Collections.Array SomeNodes)
    {
        Godot.Collections.Array<Node2D> SomeOtherNodes = new Godot.Collections.Array<Node2D>();
        foreach (Node Anode in SomeNodes)
        {
            SomeOtherNodes.Add((Node2D)Anode);
        }
        return SomeOtherNodes;
    }



    public void normalize(double[] AnArray)
    {
        int i = 0;
        foreach (double Anumber in AnArray)
        {
            AnArray[i] = Anumber/1000;
            i++;
        }
    }

   public System.Collections.Generic.IEnumerable <double> denormalize(System.Collections.Generic.IEnumerable <double> AnArray)
    {
        System.Collections.Generic.List <double> TheArray = new System.Collections.Generic.List <double>();

        foreach (double Anumber in AnArray)
        {
            TheArray.Add(Anumber*1000);
        }
            
        return TheArray;
    }



}