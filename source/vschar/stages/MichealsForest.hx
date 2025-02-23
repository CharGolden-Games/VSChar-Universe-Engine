package vschar.stages;

class MichealsForest extends BaseStage {
    var trees:BGSpriteAlt;
    
    override function create() {
        super.create();

        if (subStage == '')
        {
            trees = newSprite(0, 0, 'tres'); // lmao.
        }
    }
}