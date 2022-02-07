function Table=clusteringresult(table,dis,number)
Table=zeros(size(table));
disthreshold=dis;
numberthreshold=number;
n=1;
[row,col]=size(table);
neg_list=zeros(10000,1);
for i=1:numel(table)
    if table(i)==0
       Table(i)=-1;
        continue
    end
    if Table(i)~=0
        continue
    end
    [x,y]=ind2sub([row,col],i);
    [xn,yn]=Getindex(x,y);
    inx=sub2ind([row,col],xn,yn);
    if all(Table(inx)~=0)
        Table(x,y)=n; 
        continue
    end
    inx1=inx(Table(inx)==0);
    condition=abs(table(inx1)-table(x,y))<disthreshold;
    if any(condition)
        position=inx1(condition);
        len=length(position);
        neg_list(1:len)=position;
        Table(position)=n;
        j=1;
        while any(neg_list)
              [x,y]=ind2sub([row,col],neg_list(j));
              [xn,yn]=Getindex(x,y);
              inx=sub2ind([row,col],xn,yn);
              inx1=inx(Table(inx)==0);
              condition=abs(table(inx1)-table(x,y))<disthreshold;
              if any(condition)
                  position=inx1(condition);
                  len1=length(position);
                  neg_list(len+1:len+len1)=position;
                  Table(position)=n;
                  neg_list(j)=0;
                  len=len+len1;
                  j=j+1;
              else
                  neg_list(j)=0;
                  j=j+1;
              end
        end
        n=n+1;
    else
       n=n+1;
       continue
    end
end
Table(Table==-1)=0;
t=sortrows(tabulate(Table(:)),-2);
t=t(t(:,2)>numberthreshold);
Table(~ismember(Table,t))=0;
function [xn,yn]=Getindex(x,y)
          xn=[x-2,x-2,x-2,x-2,x-2,x-1,x-1,x-1,x-1,x-1,x,x,x,x,x,x+1,x+1,x+1,x+1,x+1,x+2,x+2,x+2,x+2,x+2];
          yn=[y-2,y-1,y,y+1,y+2,y-2,y-1,y,y+1,y+2,y-2,y-1,y,y+1,y+2,y-2,y-1,y,y+1,y+2,y-2,y-1,y,y+1,y+2]; 
        xcondition1=xn<1;
        if any(xcondition1)
            xn(xcondition1)=xn(xcondition1)+1800;
        end
        xcondition2=xn>1800;
        if any(xcondition2)
            xn(xcondition2)=xn(xcondition2)-1800;
        end
        ycondition1=yn<1;
        if any(ycondition1)
            yn(ycondition1)=[];
            xn(ycondition1)=[];
        end
        ycondition2=yn>32;
        if any(ycondition2)
            yn(ycondition2)=[];
            xn(ycondition2)=[];
        end
end
end





        


