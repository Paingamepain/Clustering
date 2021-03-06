function mergeresult=merge2(table,result,dis,AZUgap)
    mergeresult=result;
    t=sortrows(tabulate(result(:)),-2);
    t(1,:)=[];
    list=size(t,1);
    [row,col]=size(table);
    Min=[];
    MinY=[];
    Max=[];
    MaxY=[];
    ColR={};
    RowR={};
    for i=1:list
        L=find(mergeresult==t(i));
        a=min(table(L));
        Min=[Min,a];
        c=max(table(L));
        Max=[Max,c];
        [ROW,COL]=ind2sub([row,col],L);
        ColR{1,i}=COL;
        RowR{1,i}=ROW;
        MinY=[MinY,min(ROW)];
        MaxY=[MaxY,max(ROW)];
    end
    [X,Y]=ind2sub([row,col],MinY);
    MinY=X;
    [X,Y]=ind2sub([row,col],MaxY);
    MaxY=X;
    for i=1:list-1
        for j=i+1:list
            ROWGAP=min(abs(MinY(i)-MaxY(j)),abs(MinY(j)-MaxY(i)));
            Judge=intersect(ColR{i},ColR{j});
            if isempty(Judge)
                if (abs(Min(i)-Min(j))<dis) && (ROWGAP<AZUgap)
                    mergeresult(result==t(j))=t(i);
                    t(j)=t(i);
                    continue
                end
                if (abs(Max(i)-Max(j))<dis) && (ROWGAP<AZUgap)
                    mergeresult(result==t(j))=t(i);
                    t(j)=t(i);
                    continue
                end
                if (abs(Max(i)-Min(j))<dis) && (ROWGAP<AZUgap)
                    mergeresult(result==t(j))=t(i);
                    t(j)=t(i);
                    continue
                end
                if (abs(Min(i)-Max(j))<dis) && (ROWGAP<AZUgap)
                    mergeresult(result==t(j))=t(i);
                    t(j)=t(i);
                    continue
                end
            else
               [rowgap,disgap]=nearestposition(Judge);
               if (rowgap<AZUgap) && (disgap<dis)
                   mergeresult(result==t(j))=t(i);
                    t(j)=t(i);
                    continue
               end
            end
                
        end
    end
    function [A,B]=nearestposition(judge)
        len=length(judge);
        Minrowgap=[];
        Valuegap=[];
        for m=1:len
            rownumberimin=min(RowR{i}(ColR{i}==judge(m)));
            rownumberimax=max(RowR{i}(ColR{i}==judge(m)));
            rownumberjmin=min(RowR{j}(ColR{j}==judge(m)));
            rownumberjmax=max(RowR{j}(ColR{j}==judge(m)));
            e=abs(rownumberimin-rownumberjmax);
            f=abs(rownumberjmin-rownumberimax);
            if e>f
                value=abs(table(rownumberjmin,judge(m))-table(rownumberimax,judge(m)));
                mingap=f;
            else
                value=abs(table(rownumberimin,judge(m))-table(rownumberjmax,judge(m)));
                mingap=e;
            end
            Minrowgap(m)=mingap;
            Valuegap(m)=value;
        end
        A=min(Minrowgap);
        B=min(Valuegap(Minrowgap==A));
    end
end

